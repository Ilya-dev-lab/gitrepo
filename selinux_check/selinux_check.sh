#!/bin/bash
#Check if user has access to perform changes
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "You need to be root to perform this command"
    echo "login as root or use sudo to run the script"
    exit
fi
menu='Please enter your choice: '
echo -e "\n"
echo $menu
Option_1="Show full runtime SELinux settings"
Option_2="Would you like to change current/runtime mode"
Option_3="Would you like to change config file, reboot required(!!!)"
options=("$Option_1" "$Option_2" "$Option_3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        $Option_1)
            echo -e "\n"
            /usr/sbin/sestatus | awk 'NR==1 || NR==5 || NR==6'
            ;;
        $Option_2)
            echo -e "\n"
            echo "Current mode: " `/usr/sbin/sestatus | awk 'NR==5' | awk '{ print $3 }'`
            echo -e "\n"
            echo $menu
            choice_1="Enable  - enforcing"
            choice_2="Disable - permissive"
            choices=("$choice_1" "$choice_2" "Quit")
            select opt in "${choices[@]}"
            do
                case $opt in
                    $choice_1)
                        echo $choice_1
                        /usr/sbin/setenforce 1
                        ;;
                    $choice_2)
                        echo $choice_2
                        /usr/sbin/setenforce 0
                        ;;
                    "Quit")
                        break
                        ;;
                    *) echo "Invalid option $REPLY";;
                esac
            done
            ;;
        $Option_3)
            echo -e "\n"
            echo "Mode from config file: " `/usr/sbin/sestatus | awk 'NR==6' | awk '{ print $5 }'`
            echo -e "\n"
            echo $menu
            choice_1="enforcing - SELinux security policy is enforced."
            choice_2="permissive - SELinux prints warnings instead of enforcing."
            choice_3="disabled - No SELinux policy is loaded."
            choices=("$choice_1" "$choice_2" "$choice_3" "Quit")
            select opt in "${choices[@]}"
            do
                case $opt in
                    $choice_1)
                        echo $choice_1
                        sed -i '/^SELINUX=/c\SELINUX=enforcing' /etc/selinux/config
                        ;;
                    $choice_2)
                        echo $choice_2
                        sed -i '/^SELINUX=/c\SELINUX=permissive' /etc/selinux/config
                        ;;
                    $choice_3)
                        echo $choice_3
                        sed -i '/^SELINUX=/c\SELINUX=disabled' /etc/selinux/config
                        ;;
                    "Quit")
                        break
                        ;;
                    *) echo "Invalid option $REPLY";;
                esac
            done
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done
