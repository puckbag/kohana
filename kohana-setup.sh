#!/bin/bash

# http://kohanaframework.org/3.2/guide/kohana/tutorials/git

# http://stackoverflow.com/a/8088167
define(){ IFS='\n' read -r -d '' ${1}; }


##########################################################################################
# File: example.htaccess
#----------------------------------------------------------------------------------------#
define HTACCESS <<'EOF'
# Production or Development environment
SetEnv KOHANA_ENV DEVELOPMENT
#SetEnv KOHANA_ENV PRODUCTION

# Turn on URL rewriting
RewriteEngine On

# Installation directory
RewriteBase /

# Protect hidden files from being viewed
<Files .*>
        Order Deny,Allow
        Deny From All
</Files>

# Protect application and system files from being viewed
RewriteRule ^(?:application|modules|system)\b.* index.php/$0 [L]

# Allow any files or directories that exist to be displayed directly
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

# Rewrite all other URLs to index.php/URL
RewriteRule .* index.php/$0 [PT]
EOF
#----------------------------------------------------------------------------------------#


##########################################################################################
# File: .gitignore
#----------------------------------------------------------------------------------------#
define GITIGNORE <<'EOF'
.htaccess
EOF
#----------------------------------------------------------------------------------------#


##########################################################################################
# File: application/config/.gitignore
#----------------------------------------------------------------------------------------#
define APPLICATION_CONFIG_GITIGNORE <<'EOF'
*.php
EOF
#----------------------------------------------------------------------------------------#


PROJECT=$1
CWD=`cwd`

mkdir $PROJECT
cd $PROJECT

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

wget https://github.com/puckbag/kohana-kohana/raw/3.2/puckbag/index.php --no-check-certificate
wget https://github.com/puckbag/kohana-kohana/raw/3.2/puckbag/application/bootstrap.php --no-check-certificate -O application/bootstrap.php

echo "$HTACCESS" > example.htaccess
echo "$GITIGNORE" > .gitignore
echo "$APPLICATION_CONFIG_GITIGNORE" > application/config/.gitignore

git add .
git commit -m 'Added initial directory structure'


cd $CWD



