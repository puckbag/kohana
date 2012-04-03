#!/bin/bash

# http://kohanaframework.org/3.2/guide/kohana/tutorials/git

PROJECT="$1"
CWD=`pwd`

mkdir "$PROJECT"
cd "$PROJECT"

git init

git submodule add git://github.com/puckbag/kohana-core.git system
git submodule add git://github.com/kohana/database.git modules/auth
git submodule add git://github.com/kohana/database.git modules/database
git submodule add git://github.com/kohana/database.git modules/orm
git submodule init
git submodule foreach 'git checkout 3.2/master && git pull origin 3.2/master'
cd system && git checkout 3.2/puckbag && git pull origin 3.2/puckbag && cd ..

git commit -m 'Added initial submodules'

mkdir -p application/classes/{controller,model}
mkdir -p application/{config,views}
mkdir -m 0777 -p application/{cache,logs}

echo '[^.]*' > application/logs/.gitignore
echo '[^.]*' > application/cache/.gitignore

wget https://github.com/puckbag/kohana-kohana/raw/3.2/puckbag/.gitignore --no-check-certificate
wget https://github.com/puckbag/kohana-kohana/raw/3.2/puckbag/example.htaccess --no-check-certificate
wget https://github.com/puckbag/kohana-kohana/raw/3.2/puckbag/index.php --no-check-certificate
wget https://github.com/puckbag/kohana-kohana/raw/3.2/puckbag/application/bootstrap.php --no-check-certificate -O application/bootstrap.php
wget https://github.com/puckbag/kohana-kohana/raw/3.2/puckbag/application/config/.gitignore --no-check-certificate -O application/config/.gitignore

git add .
git commit -m 'Added initial directory structure'


cd "$CWD"



