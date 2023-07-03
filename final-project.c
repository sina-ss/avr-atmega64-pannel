#include <mega64.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alcd.h>

#define LED1 PORTD.0
#define LED2 PORTD.1

typedef struct
{
    char username[20];
    char password[20];
} User;

User predefinedUsers[] = { {"user1", "pass1"}, {"user2", "pass2"}, {"user3", "pass3"}, {"user4", "pass4"} };
User registeredUsers[10];  // Limit new users to 10
int numPredefinedUsers = sizeof(predefinedUsers) / sizeof(User);
int numRegisteredUsers = 0;

char inputBuffer[20];
int bufferIndex = 0;
char tempPassword[20];

char loggedUser[20];
int isRegistering = 0;

void send_string(char *str)
{
    while (*str != 0)
    {
        while ((UCSR0A & (1 << UDRE0)) == 0);
        UDR0 = *str;
        str++;
    }
}

void check_user()
{
    int i;
    for (i = 0; i < numPredefinedUsers; i++)
    {
        if (strcmp(predefinedUsers[i].username, inputBuffer) == 0)
        {
            send_string("\nEnter Password: ");
            return;
        }
    }
    for (i = 0; i < numRegisteredUsers; i++)
    {
        if (strcmp(registeredUsers[i].username, inputBuffer) == 0)
        {
            send_string("\nEnter Password: ");
            return;
        }
    }
    // If username not found, register new user
    isRegistering = 1;
    strcpy(registeredUsers[numRegisteredUsers].username, inputBuffer);
    send_string("\nNew Password: ");
}

void check_password()
{
    int i;
    for (i = 0; i < numPredefinedUsers; i++)
    {
        if (strcmp(predefinedUsers[i].username, inputBuffer) == 0)
        {
            if (strcmp(predefinedUsers[i].password, inputBuffer) == 0)
            {
                strcpy(loggedUser, predefinedUsers[i].username);
                LED2 = 1; // Turn on the LED2
                send_string("\nLogin Successful!\n");
                return;
            }
        }
    }
    for (i = 0; i < numRegisteredUsers; i++)
    {
        if (strcmp(registeredUsers[i].username, inputBuffer) == 0)
        {
            if (strcmp(registeredUsers[i].password, inputBuffer) == 0)
            {
                strcpy(loggedUser, registeredUsers[i].username);
                LED2 = 1; // Turn on the LED2
                send_string("\nLogin Successful!\n");
                return;
            }
        }
    }
    send_string("\nLogin Failed!\n");
    LED2 = 0; // Turn off the LED2
}

void check_new_password()
{
    strcpy(tempPassword, inputBuffer);
    send_string("\nConfirm Password: ");
}

void check_confirm_password()
{
    if (strcmp(tempPassword, inputBuffer) == 0)
    {
        strcpy(registeredUsers[numRegisteredUsers].password, tempPassword);
        numRegisteredUsers++;
        send_string("\nRegistration Successful!\n");
    }
    else
    {
        send_string("\nRegistration Failed!\n");
    }
    isRegistering = 0;
}

interrupt [USART0_RXC] void usart_rx_isr(void)
{
    char data = UDR0;
    if (data == '\n')
    {
        inputBuffer[bufferIndex] = '\0'; // Null-terminate the received string
        if (loggedUser[0] == '\0')
        {
            if (isRegistering == 0)
            {
                check_user();
            }
            else if (isRegistering == 1)
            {
                check_new_password();
                isRegistering++;
            }
            else
            {
                check_confirm_password();
            }
        }
        else
        {
            check_password();
        }
        bufferIndex = 0;
    }
    else
    {
        inputBuffer[bufferIndex] = data;
        bufferIndex++;
    }
}

void main(void)
{
    // Port D is output for LEDs
    DDRD.0 = 1;
    DDRD.1 = 1;

    // Turn on the LED1
    LED1 = 1;

    // Initialize USART
    UCSR0A = 0x00;
    UCSR0B = 0x18;
    UCSR0C = 0x06;
    UBRR0L = 51; // for 9600 bps with 8MHz clock

    // Enable Global Interrupts
    #asm("sei")

    send_string("Enter Username: ");

    while (1)
    {
        // Your code here
    }
}
