#!/bin/bash
set -e

mise trust /app/mise.toml && mise install

# Activate mise environment so mix and other tools are available
eval "$(mise activate bash)"

# Install mix local tools (required for ElixirLS and mix archives)
mix local.hex --force
mix local.rebar --force

# Install mix archives for phx_new and igniter
mix archive.install hex phx_new --force
mix archive.install hex igniter_new --force

# Add conditional message to shell initialization file
# This message will appear in new shells only when mix.exs is not present
MESSAGE_BLOCK='
# Show project setup instructions if mix.exs doesn'\''t exist
if [ ! -f /app/mix.exs ]; then
  echo "This dev container does not yet have a mix.exs file for your project."
  echo ""
  echo "Here are the commands to create a new Igniter project with Phoenix and Ash:"
  echo ""
  echo "# Create a new Igniter project with Phoenix and Ash"
  echo "mix igniter.new my_app --with phx.new --install ash,ash_phoenix \\"
  echo "  --install ash_postgres,ash_authentication  --install ash_authentication_phoenix,ash_admin \\"
  echo "  --install live_debugger   --auth-strategy magic_link --setup --yes"
  echo ""
  echo "# Or create a new Phoenix project:"
  echo "mix phx.new my_app"
  echo ""
  echo "# And then copy the new project into the current directory"
  echo "shopt -s dotglob && mv ./my_app/* ./ -f && rmdir my_app"
  echo ""
fi
'

echo "$MESSAGE_BLOCK" >> ~/.bashrc
echo "$MESSAGE_BLOCK" >> ~/.zshrc
