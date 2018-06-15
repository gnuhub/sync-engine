## Start Nylas Sync Engine  on Mac

### 0

```
git clone https://github.com/gnuhub/sync-engine.git
cd sync-engine
git checkout gnuhub
git pull origin gnuhub
```

### 1

if you are in china,run
```
./1.mac.python.setup.sh zh

```

if you are not in china
```
./1.mac.python.setup.sh

```

### 2

```
./2.mac.setup.sh
```

### 3

```
./3.mac.pyton.pip.install.sh
```

### 4

```
./4.mac.fix.mysql.sh
```

### 5 the mysql user is root and the password is empty using XAMPP MYSQL server

```
5.mac.db.setup.sh
```

### 6

```
./6.mac.engin.start.sh
```

### 7

```
./7.mac.email.auth.sh youremail@gmail.com
```

### 8

```
./8.mac.api.start.sh
```

### 9

```
./9.mac.api.test.sh
```