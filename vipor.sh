#!/bin/bash

# Color Variables
CYAN="\033[0;36m"
NC="\033[0m" # No Color
INFO="\033[0;32m"
ERROR="\033[0;31m"
SUCCESS="\033[0;32m"
WARN="\033[0;33m"

# Display a message after logo
echo -e "${CYAN}🎉 Displaying Aniani!!! ${NC}"

# Display logo directly from URL
echo -e "${CYAN}✨ Displaying logo... ${NC}"
wget -qO- https://raw.githubusercontent.com/Chupii37/Chupii-Node/refs/heads/main/Logo.sh | bash

# Update and upgrade system packages
echo -e "${INFO}🔄 Updating and upgrading packages... ${NC}"
sudo apt update && sudo apt upgrade -y

# Check if Docker is installed
echo -e "${INFO}🔍 Checking Docker installation... ${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${ERROR}🚫 Docker not found. Installing Docker... ${NC}"
    
    # Install Docker
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo -e "${SUCCESS}✔️ Docker successfully installed! ${NC}"
else
    echo -e "${SUCCESS}✔️ Docker is already installed. ${NC}"
fi

# Clean up unnecessary packages
echo -e "${INFO}🧹 Cleaning up unnecessary packages... ${NC}"
sudo apt-get autoremove -y
sudo apt-get clean
echo -e "${SUCCESS}✅ Unnecessary packages removed! ${NC}"

# Prompt user to enter wallet address
echo -e "${CYAN}💸 Enter your wallet address: ${NC}"
read address

# Choose server pool
echo -e "${CYAN}🌐 Choose your server pool: ${NC}"
echo "a. Singapore"
echo "b. China Hong Kong"
echo "c. Asia Korea"
echo "d. Australia Sydney"
echo "e. France Gravelines"
echo "f. Germany Frankfurt"
echo "g. Ukraine Kiev"
echo "h. Finland Helsinki"
echo "i. Romania Bucharest"
echo "j. Poland Warsaw"
echo "k. Kazakhstan Almaty"
echo "l. USA (West) California"
echo "m. USA (North East) Ohio"
echo "n. Turkey Istanbul"
echo "o. USA (South East) Georgia"
echo "p. USA (South West) Texas"
echo "q. Canada Montreal"
echo "r. Russia Moscow"
echo "s. South America Brazil"
read server_choice

# Prompt user to choose mining pool or solo pool
echo -e "${CYAN}💎 Choose pool type: ${NC}"
echo "a. Mining pool"
echo "b. Solo pool"
read pool_type

# Map server choice to pool addresses based on pool type
if [[ "$pool_type" == "a" ]]; then
    # Mining pool addresses
    case $server_choice in
        a) pool="stratum+tcp://sg.vipor.net:5040" ;;
        b) pool="stratum+tcp://cn.vipor.net:5040" ;;
        c) pool="stratum+tcp://ap.vipor.net:5040" ;;
        d) pool="stratum+tcp://au.vipor.net:5040" ;;
        e) pool="stratum+tcp://fr.vipor.net:5040" ;;
        f) pool="stratum+tcp://de.vipor.net:5040" ;;
        g) pool="stratum+tcp://ua.vipor.net:5040" ;;
        h) pool="stratum+tcp://fi.vipor.net:5040" ;;
        i) pool="stratum+tcp://ro.vipor.net:5040" ;;
        j) pool="stratum+tcp://pl.vipor.net:5040" ;;
        k) pool="stratum+tcp://kz.vipor.net:5040" ;;
        l) pool="stratum+tcp://usw.vipor.net:5040" ;;
        m) pool="stratum+tcp://us.vipor.net:5040" ;;
        n) pool="stratum+tcp://tr.vipor.net:5040" ;;
        o) pool="stratum+tcp://usse.vipor.net:5040" ;;
        p) pool="stratum+tcp://ussw.vipor.net:5040" ;;
        q) pool="stratum+tcp://ca.vipor.net:5040" ;;
        r) pool="stratum+tcp://ru.vipor.net:5040" ;;
        s) pool="stratum+tcp://sa.vipor.net:5040" ;;
        *) echo -e "${ERROR}🚫 Invalid server choice. Exiting. ${NC}" && exit 1 ;;
    esac
elif [[ "$pool_type" == "b" ]]; then
    # Solo pool addresses
    case $server_choice in
        a) pool="stratum+tcp://sg.vipor.net:5045" ;;
        b) pool="stratum+tcp://cn.vipor.net:5045" ;;
        c) pool="stratum+tcp://ap.vipor.net:5045" ;;
        d) pool="stratum+tcp://au.vipor.net:5045" ;;
        e) pool="stratum+tcp://fr.vipor.net:5045" ;;
        f) pool="stratum+tcp://de.vipor.net:5045" ;;
        g) pool="stratum+tcp://ua.vipor.net:5045" ;;
        h) pool="stratum+tcp://fi.vipor.net:5045" ;;
        i) pool="stratum+tcp://ro.vipor.net:5045" ;;
        j) pool="stratum+tcp://pl.vipor.net:5045" ;;
        k) pool="stratum+tcp://kz.vipor.net:5045" ;;
        l) pool="stratum+tcp://usw.vipor.net:5045" ;;
        m) pool="stratum+tcp://us.vipor.net:5045" ;;
        n) pool="stratum+tcp://tr.vipor.net:5045" ;;
        o) pool="stratum+tcp://usse.vipor.net:5045" ;;
        p) pool="stratum+tcp://ussw.vipor.net:5045" ;;
        q) pool="stratum+tcp://ca.vipor.net:5045" ;;
        r) pool="stratum+tcp://ru.vipor.net:5045" ;;
        s) pool="stratum+tcp://sa.vipor.net:5045" ;;
        *) echo -e "${ERROR}🚫 Invalid server choice. Exiting. ${NC}" && exit 1 ;;
    esac
else
    echo -e "${ERROR}🚫 Invalid pool type. Exiting. ${NC}"
    exit 1
fi

# Prompt user to enter worker name
echo -e "${CYAN}🧑‍💻 Enter your worker name: ${NC}"
read worker_name

# Ask for CPU usage
echo -e "${CYAN}💻 Enter the number of CPUs you want to use (example: 2 for 2 CPUs): ${NC}"
read cpu_count
cpu_count=${cpu_count:-1}  # Default to 1 if empty
if ! [[ "$cpu_count" =~ ^[0-9]+$ ]]; then
    echo -e "${ERROR}🚫 Invalid input for CPU count. Please enter a number. ${NC}"
    exit 1
fi

cpu_devices=""
for ((i=0; i<cpu_count; i++)); do
    cpu_devices="--cpu $i $cpu_devices"
done

# Check if directory exists, create if not
echo -e "${INFO}📂 Checking directory... ${NC}"
if [ -d "vipor-docker" ]; then
  echo -e "${INFO}📂 Directory 'vipor-docker' already exists. ${NC}"
else
  mkdir vipor-docker
  echo -e "${SUCCESS}✅ Directory 'vipor-docker' created successfully! ${NC}"
fi

# Change to the directory
cd vipor-docker

# Get public IP address
public_ip=$(curl -s ifconfig.me)
if [ -z "$public_ip" ]; then
  echo -e "${ERROR}🚫 Failed to retrieve public IP address. Exiting. ${NC}"
  exit 1
fi

# Create Dockerfile with user input
echo -e "${INFO}📝 Creating Dockerfile... ${NC}"
cat <<EOL > Dockerfile
# Using the latest Ubuntu as the base image
FROM ubuntu:22.04

# Install necessary tools
RUN apt-get update && apt-get install -y \\
    wget \\
    tar

WORKDIR /vipor-docker

# Download and extract hellminer
RUN wget https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64.tar.gz && \\
    tar -xvzf hellminer_linux64.tar.gz && \\
    chmod +x hellminer && \\
    rm hellminer_linux64.tar.gz

# Run the miner with provided parameters
CMD ["/bin/bash", "-c", "./hellminer -c $pool -u $address.$worker_name -p x $cpu_devices"]
EOL

# Set container name and build the image
container_name="vipor-docker"
echo -e "${INFO}⚙️ Building Docker image... ${NC}"
docker build -t $container_name .

# Run the Docker container
echo -e "${INFO}🚀 Running Docker container... ${NC}"
docker run -d --name $container_name --restart unless-stopped -v /usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu $container_name

# Success message with emojis
echo -e "${SUCCESS}🎉🚀✨ Your Docker container is now running with automatic restart enabled! ${NC}"
echo -e "${INFO}🔍 To view the logs in real-time, run the following command: ${NC}"
echo -e "${INFO}docker logs -f $container_name ${NC}"
