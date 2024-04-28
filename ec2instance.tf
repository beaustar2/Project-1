resource "aws_instance" "javawebapp" {
  ami                    = "ami-05a36e1502605b4aa"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.javawebapp-public-subnet.id
  key_name               = "kiki"
  vpc_security_group_ids = [aws_security_group.javawebapp-sg.id]
  user_data              = <<-EOF
   #!/bin/bash
   sudo yum update -y
   sudo yum -y install git wget java-11*
   wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz
   tar -zxvf apache-maven-3.9.5-bin.tar.gz
   export PATH=$PATH:/opt/apache-maven-3.9.5/bin
   echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk" >> ~/.bashrc
   echo "export M2_HOME=/usr/share/maven" >> ~/.bashrc
   echo "export MAVEN_HOME=/usr/share/maven" >> ~/.bashrc
   echo "export PATH=\\\$${M2_HOME}/bin:\\\$${PATH}" >> ~/.bashrc
   curl -fsSL https://get.docker.com -o install-docker.sh
   sudo sh install-docker.sh
   sudo systemctl start docker 
   sudo git clone https://github.com/beaustar2/Project-1.git /home/centos/Project-1
   cd /home/centos/Project-1
   mvn package
   
   EOF
  private_ip             = "10.0.1.20"
  tags = {
    Name = "javawebapp"
  }
}
resource "aws_instance" "tomcat" {
  ami                    = "ami-05a36e1502605b4aa"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.javawebapp-public-subnet.id
  key_name               = "kiki"
  vpc_security_group_ids = [aws_security_group.javawebapp-sg.id]
  user_data              = <<-EOF
   #!/bin/bash
   sudo yum update -y
   sudo yum -y install git wget unzip java-11*
   echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk" >> ~/.bashrc
   curl -fsSL https://get.docker.com -o install-docker.sh
   sudo sh install-docker.sh
   sudo systemctl start docker 
   wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.94/bin/apache-tomcat-7.0.94.tar.gz -P /home/centos
   tar xvf /home/centos/apache-tomcat-7.0.94.tar.gz -C /home/centos
   sudo /home/centos/apache-tomcat-7.0.94/bin/startup.sh
   sudo chown -R centos:centos /home/centos/apache-tomcat-7.0.94/webapps/
   
   EOF
  private_ip             = "10.0.1.11"
  tags = {
    Name = "tomcat"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-05a36e1502605b4aa"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.javawebapp-public-subnet.id
  key_name               = "kiki"
  vpc_security_group_ids = [aws_security_group.javawebapp-sg.id]
  user_data              = <<-EOF
#!/bin/bash
sudo yum update -y
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
sudo systemctl start docker 
sudo yum install -y git wget java-11*
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
EOF
  private_ip             = "10.0.1.12"
  tags = {
    Name = "jenkins"
  }
}