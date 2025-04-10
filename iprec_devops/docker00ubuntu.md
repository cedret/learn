

    1  df -h
    2  sudo apt update
    3  sudo apt install docker.io
    4  docker --version 
    5  sudo docker container ls
    6  sudo docker container stop 58
    7  history 
    8  sudo docker image ls
    9  df -h
   10  sudo docker container ls
   11  sudo docker image ls
   12  sudo docker hello-world
   13  sudo docker run hello-world
   14  sudo docker image ls
   15  sudo docker container ls
   16  sudo docker container ls -a
   17  sudo docker container rm 1c
   18  sudo docker pull ubuntu:latest
   19  sudo docker image ls
   20  sudo docker run ubuntu:latest
   21  sudo docker container ls -a
   22  sudo docker run -it unbuntu:latest
   23  sudo docker run -it ubuntu:latest
   24  sudo docker container ls -a
   25  sudo docker container rm 58 59
   26  sudo docker container ls -a
   27  sudo docker run -it --detach --name ubuntu:latest
   28  sudo docker run -it --detach --name mubu ubuntu:latest
   29  sudo docker container ls
   30  sudo docker container ls -a
   31  sudo docker container start mubu
   32  sudo docker container ls
   33  sudo docker container inspect mubu
   34  sudo docker container inspect mubu | grep IPAddress
   35  mkdir monimage
   36  cd monimage
   37  ip a
   38  cd ..
   39  sudo apt install openssh-server 
   40  sudo systemctl start ssh
   41  sudo systemctl enable ssh
   42  sudo systemctl status ssh
   43  ip a
   44  ls
   45  cd monimage/
   46  ls
   47  cat dockerfile
   48  cat server.py 
   49  sudo docker image build . -t monimage:latest
   50  nano dockerfile
   51  sudo docker image build . -t monimage:latest
   52  history 
   53  sudo docker image build . -t mon_image:latest
   54  cd monimage
   55  ls
   56  sudo docker image build . -t mon_image:latest
   57  exit
   58  ls
   59  cd cedrik/
   60  ls
   61  cd monimage/
   62  ls
   63  vim dockerfile
   64  sudo apt install vim
   65  nano dockerfile
   66  ls
   67  nano server
   68  ls
   69  mv server server.py
   70  ls -al
   71  cat server.py 
   72  cat dockerfile 
   73  docker image build . -t monimage:latest
   74  sudo docker image build . -t monimage:latest
   75  python --version
   76  python3 --version
   77  sudo pip3 install flask
   78  sudo python3 install flask
   79  nano dockerfile
   80  cp dockerfile dockerfile.0
   81  nano dockerfile
   82  sudo docker image build . -t monimage:latest
   83  ls
   84  mv dockerfile.0 dockerfile.sos
   85  ls
   86  sudo docker image ls
   87  history 
   88  sudo docker image build . -t monimage:latest
   89  cd monimage/
   90  sudo docker image build . -t monimage:latest
   91  docker container run -p 5000:5000 -d monimage:latest
   92  sudo docker container run -p 5000:5000 -d monimage:latest
   93  ip a
   94  docker image save --output dockimag.tar monimage
   95  sudo docker image save --output dockimag.tar monimage
   96  ls -al
   97  sudo docker container ls
   98  sudo docker image rm monimage
   99  sudo docker container stop 3d
  100  sudo docker container stop e4
  101  sudo docker container ls
  102  sudo docker image rm monimage
  103  sudo docker image rm -f monimage
  104  ls
  105  docker image load --input dockimag.tar
  106  sudo docker image load --input dockimag.tar
  107  ls
  108  sudo docker container ls
  109  sudo docker container ls -a
  110  ip a
  111  ls
  112  history 
