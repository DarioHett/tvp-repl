#!/bin/bash
if ! [ -x "$(command -v vim)" ];
then
	echo 'Error: vim is not installed.' >&2;
	read -p "Will install vim now. Press [Enter] to continue.";
	sudo apt-get install vim-gtk;
elif [ $(vim --version | grep -c '+clipboard') -eq 0 ];
then
	echo 'Error: vim is not compiled with +clipboard.' >&2;
	read -p "Will install vim-gtk now. Press [Enter] to continue.";
	sudo apt-get install vim-gtk;
else 
	echo "Vim installation seems fine.";
fi

if ! [ -x "$(command -v tmux)" ];
then
	echo 'Error: tmux is not installed.' >&2;
	read -p "Will install tmux now. Press [Enter] to continue.";
	sudo apt-get install tmux;
else 
	echo "tmux installation seems fine.";
fi

if ! [ -x "$(command -v xclip)" ];
then
	echo 'Error: xclip is not installed.' >&2;
	read -p "Will install xclip now. Press [Enter] to continue.";
	sudo apt-get install xclip;
else 
	echo "xclip installation seems fine.";
fi

#rm .tmux.conf
if [ ! -f ~/.tmux.conf ];
then 
touch ~/.tmux.conf;
fi

if [ $(cat ~/.tmux.conf | grep -c "#tvp-repl") -eq 0 ];
then
	echo "#tvp-repl" >> .tmux.conf
	echo "bind-key Enter run \"tmux send-keys -t 0 C-c\" \\; run \"tmux select-pane -t 1\" \\; run \"tmux set-buffer \\\"\$(xclip -o -sel clipboard)\\\"; tmux paste-buffer\" \\; run \"tmux send-keys -t 1 Enter\" \\; run \"tmux select-pane -t 0\"" >> .tmux.conf
	echo ".tmux.conf appended."
else
        echo ".tmux.conf is fine.";
fi

#rm .vimrc
if [ ! -f ~/.vimrc ];
then 
	touch ~/.vimrc;
fi 
if [ $(cat ~/.vimrc | grep -c "\" tvp-repl") -eq 0 ];
then
	echo "\" tvp-repl" >> .vimrc
	echo "set clipboard=unnamedplus" >> .vimrc
	echo "vnoremap <C-c> \"+y" >> .vimrc
	echo ".vimrc appended."
else
        echo ".vimrc is fine.";
fi

if [ ! -d ~/bin ]; then
	mkdir ~/bin;
fi

if [ ! -f ~/bin/tvp-repl ]; then
	touch ~/bin/tvp-repl
	chmod 777 ~/bin/tvp-repl
	echo "#!/bin/sh" >> ~/bin/tvp-repl
	echo "FILE=\$1" >> ~/bin/tvp-repl
	echo "tmux new-session \\; \\" >> ~/bin/tvp-repl
	echo "	send-keys 'vim '\${FILE}';clear' C-m \\; \\" >> ~/bin/tvp-repl
	echo "	split-window -h \\; \\" >> ~/bin/tvp-repl
	echo "	send-keys 'clear; ipython '${FILE} C-m \\; \\" >> ~/bin/tvp-repl
	echo "	select-pane -t 0\\;" >> ~/bin/tvp-repl
fi

echo "Run \"source ~/bin/tvp-repl\" to run the setup."
echo "Select code in VISUAL mode of left pane."
echo "Execute in right pane with: C-b Enter."
. ~/.profile

