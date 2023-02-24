#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

#Display numbered list of services you offerbefore the first prompt for input with the format: #)<service>, where # is the service_id
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "What would you like today?"

  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  #echo -e "\n1) cut\n2) shave\n3) color"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) echo "You selected a cut";;
    2) echo "You selected a shave" ;;
    3) echo "You selected a color" ;;
    #If you pick a service that doesn't exist, you should be shown the same list of services again.
    *) MAIN_MENU "Please enter a valid option.";;
  esac


}


MAIN_MENU

#Prompt users to enter a service_id, phone number, name (if not already a customer) and a time. 
#Use "read" to read these inputs into variables named: SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, SERVICE_TIME.
echo -e "\nPlease enter your phone number:"
read CUSTOMER_PHONE

#find customerphone name
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
#if not found
if [[ -z $CUSTOMER_NAME ]]
then
  #make new customer
  echo "Please enter your name:"
  read CUSTOMER_NAME
  NEW_CUSTOMER_RESULTS=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$NAME')")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

echo -e "\nPlease enter a time for your appointment:"
read SERVICE_TIME

NEW_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME') ")
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

#If a phone number entered doesn't exist, you should get the customer name & enter it, and the phone number, into the "customers" table.

