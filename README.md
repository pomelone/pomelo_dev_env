# Installation Steps

## Common Environment

1. Install **wget, curl, git, gcc, g++, gdb, vim, zip, unzip**, option package: **tldr, tmux**

2. Execute **setup.sh**

    `bash setup.sh`

4. Vim support syntax highlighting

    If a supported file type exists but doesn't work, add [vim](https://github.com/vim/vim.git) plugin to `~/vim/` and configuration file: **.vimrc**:

    `au BufNewFile,BufRead *.scala setf scala`

    Add a path to `runtimepath`:

    `set runtimepath+=~/.vim`

    ```bash
    git clone https://github.com/vim/vim.git

    cp -f ./vim/runtime/filetype.vim ~/.vim/

    [[ ! -d ~/.vim/ftplugin ]] && mkdir ~/.vim/ftplugin
    cp -f ./vim/runtime/ftplugin/*.vim ~/.vim/ftplugin/

    [[ ! -d ~/.vim/syntax ]] && mkdir ~/.vim/syntax
    cp -f ./vim/runtime/syntax/*.vim ~/.vim/syntax/
    ```

3. Install git & bash completion
    ```bash
    # install
    [ ! -d ~/.bin/completion ] && mkdir -p ~/.bin/completion
    
    mkdir ~/.bin/completion/bash && cd ~/.bin/completion/bash && git clone https://github.com/scop/bash-completion.git && cd -

    mkdir ~/.bin/completion/git && cd ~/.bin/completion/git && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && cd -


    # .bashrc conf
    # bash completion
    # https://github.com/scop/bash-completion
    [ -f $HOME/.bin/completion/bash/bash_completion ] && \
        . $HOME/.bin/completion/bash/bash_completion
    
    # git completion
    # https://github.com/git/git/tree/master/contrib/completion
    [ -f $HOME/.bin/completion/git/git-completion.bash ] && \
        . $HOME/.bin/completion/git/git-completion.bash
    ```

## Conda

1. Install **anaconda**

    * download [miniconda](https://docs.conda.io/projects/miniconda) ~~[anaconda installer](https://www.anaconda.com/products/individual#Downloads)~~

    * execute installer and configure conda-path `~/.bin/conda`.

    * choose **yes** to **conda init**

    * cancel the **base** environment that is automatically activated every time conda starts: `conda config --set auto_activate_base false`

    * configure source mirror, profile: `~/.condarc`

2. conda usage:

    * install plug-in: `conda install nb_conda`

    * uninstall plug-in: `conda remove nb_conda` or `conda uninstall nb_conda`

    * create environment: `conda create -n py-2.7 python=2.7.15` or `conda create -n py-3.6 python=3.6.5`. If you want to use it in the notebook, you need to install **ipykernel** `pip install ipykernel`

    * remove environment: `conda remove -n py-2.7 --all`

    * activate environment: `conda activate py-2.7`

    * deactivate environment: `conda deactivate`

    * show python versions: `conda search python`

    * install a specific version package: `conda install package=version` or `pip install package==version`

## Vim Plugin

1. Install **nvm** and **node.js** ( lower than **coc.nvim** required version )

    * open [nvm website](https://github.com/nvm-sh/nvm), follow the manual to install

    * configure default nvm version, eg ( *to default to the latest LTS version* ): `echo "lts/*" > .nvmrc`

    * configure source mirror [**option**]

    * install and use **node.js**

        * show node versions: `nvm ls-remote`

        * install a version: `nvm install node-version`

        * use a version: `nvm use node-version`

2. Install **vim** ( lower than **coc.nvim** required version )

    * download [vim](https://www.vim.org) source code

    * execute `./configure --prefix=$HOME/.bin/vim`

    * compile and install `make -j 16 && make install`

    * link executable file to **~/.bin** `ln -s $HOME/.bin/vim/bin/vim $HOME/.bin/vim`

3. Configure **vim**

    install vim-plug: `cd ~/.vim/autoload && wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && cd -`

    ```
    " vim plugged
    " https://github.com/junegunn/vim-plug
    call plug#begin('~/.vim/plugged')

    " alignment plug
    Plug 'godlygeek/tabular', {'for': ['c', 'cpp', 'cs', 'css', 'go', 'javascript', 'html/xhtml', 'make', 'lua', 'php', 'plsql', 'perl', 'objc', 'proto', 'r', 'ruby', 'scala', 'sql', 'tex', 'yaml', 'java', 'python', 'sh', 'vim', 'markdown']}

    " lsp (language server protocol)
    " coc.nvim: https://github.com/neoclide/coc.nvim
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    call plug#end()


    " coc.nvim conf
    "let g:coc_node_path = '~/.bin/node-16.13.0/bin/node'
    let g:coc_config_home = '~/.config/vim'
    ```

4. Configure Plugin

    * install plug-in: `:PlugInstall`

    * update plug-in: `:PlugUpdate`

    * update **[plug.vim](https://github.com/junegunn/vim-plug)**: `:PlugUpgrade`

    * install **[coc.nvim](https://github.com/neoclide/coc.nvim) extensions**: `CocInstall coc-sh coc-json coc-markdownlint coc-pyright coc-metals coc-clangd coc-java` for language **shell, json, markdown, python, scala, c/c++, java**

    * if note `[coc.nvim] "node" is not executable, checkout https://nodejs.org/en/download/`, configure `let g:coc_node_path = '$node_home/bin/node'` in **.vimrc**

    * install **clangd.install**: `:CocCommand clangd.install`, then add **clangd** into **$PATH** `ln -s $HOME/.config/coc/coc-clangd-data/install/bin/clangd $HOME/.bin/clangd`

    * update **coc.nvim update extensions**: `:CocUpdate`
