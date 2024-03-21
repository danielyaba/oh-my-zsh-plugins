switch() {
    if [ -n "$1" ]; then
        if [ "$1" = "." ]; then
            echo "Invalid venv name: $1"
            exit 1
        fi

        VENV=~/Programming/venv_$1

        if [ -d "$VENV" ]; then
            if [[ "$VIRTUAL_ENV" == "$VENV" ]]; then
                echo "$1 already active"
            else
                if hash deactivate 2>/dev/null; then
                    deactivate
                fi
                source "$VENV/bin/activate"
                echo "venv $1 has been activated"
            fi
        else
            echo "Creating venv at $VENV"
            python3 -m venv "$VENV"
            source "$VENV/bin/activate"
            echo "Installing IPython"
            pip install -U pip ipython
            echo "venv $1 has been activated"
        fi
    else
        if [ -n "$VIRTUAL_ENV" ]; then
            current_venv=$(basename "$VIRTUAL_ENV")
            echo "Deactivating $current_venv"
            deactivate
        else
            current_dir=$(basename "$PWD")
            auto_venv=~/Programming/venv_$current_dir

            if [ -d "$auto_venv" ]; then
                if [[ "$VIRTUAL_ENV" == "$auto_venv" ]]; then
                    echo "$current_dir already active"
                else
                    if hash deactivate 2>/dev/null; then
                        deactivate
                    fi
                    source "$auto_venv/bin/activate"
                    echo "venv_$current_dir has been activated"
                fi
            else
                echo "Please enter a venv name for activation or create venv_<dir_name>"
            fi
        fi
    fi
}
