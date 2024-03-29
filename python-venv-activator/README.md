# Python VENV Activator

This is a zsh plugin for creating, activating and decativating python virtual-environments in a single command

## Preprration
1. Clone the repository and copy the plugin directory to oh-my-zsh custom plugin directory:
```
git clone https://github.com/danielyaba/oh-my-zsh-plugins.git
cd oh-my-zsh-plugins/python-venv-activator
cp -r python-venv-activator ~/.oh-my-zsh/custom/plugins
```

2. Add the plugin to ~/.zshrc file by editting the plugin list
```
plugins=(
  python-venv-activator
  # other plugins
  ...
)
```

3. Reload ~/.zshrc file with the command:
```
source ~/.zshrc
```

## Usage

#### Activate Virtual-Environment
To activate a venv type ```switch``` command followed by the virtual-environment name  
If the virtual-environment doesn't exist it will create and activate it
```
switch <venv-name>
```

#### Decativate Virtual-Environment
To deactivate a venv type ```switch```
```
switch
```

#### Switching Virtual-Environment
To switch between virtual-environment type ```switch ```command followed by the name of the virtual-environment  
If the virtual-environment doesn't exist it will create and activate it

 