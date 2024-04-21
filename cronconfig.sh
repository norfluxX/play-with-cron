#!/bin/bash
# Created by Bhikesh Khute - Platform Engineer
# Function to display the menu
display_menu() {
    echo "------------------------------------------"
    echo "Menu Options:"
    echo "1. Create new job in batch folder"
    echo "2. Replace/Create a new job"
    echo "3. Stop a cron job"
    echo "4. Kill all process of a job on the system"
    echo "5. Exit"
    echo "Please enter your choice:"
}

# Function for Option 1
option1() {
        echo "Enter the new job name"
        read jobname
        cat << EOF > $jobname.sh
#!/bin/bash
APP_HOME=/var/www/bcx.netlog.ca
CAKE_VERSION="cakephp-2.10.18"
export PATH=\${APP_HOME}/\${CAKE_VERSION}/app/Console:\$PATH

date >> \${APP_HOME}/\${CAKE_VERSION}/logs/$jobname.log
cd \${APP_HOME}/\${CAKE_VERSION}/app
Console/cake $jobname
EOF
        chmod +x $jobname.sh
        echo "Completed"
}

option2() {
        echo "Input the old job name"
        read old
        echo "Input new job name"
        read new
        cp /home/ubuntu/Desktop/$old.sh /home/ubuntu/Desktop/$new.sh
        sed -i "s/$old/$new/g" $new.sh
        sed -i "s/$old/$new/g" /var/spool/cron/crontabs/ubuntu
}


# Function for Option 3
option3() {
        echo "Enter the job name to be stopped"
        read jobname
        sed -i "/$jobname/s!^!#!" /var/spool/cron/crontabs/ubuntu
}

# Function for Option 4
option4() {
        echo "Enter job name to be killed"
        read jobname
        pkill $jobname
}

# Main loop for the menu
while true; do
    display_menu
    read choice

    case $choice in
        1)
            option1
            ;;
        2)
            option2
            ;;
        3)
            option3
            ;;
        4)
            option4
            ;;
        5)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please enter a valid option."
            ;;
    esac
done

