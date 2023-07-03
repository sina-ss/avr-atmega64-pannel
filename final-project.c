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

User users[] = { {"user1", "pass1"}, {"user2", "pass2"}, {"user3", "pass3"}, {"user4", "pass4"} };
int numUsers = sizeof(users) / sizeof(User);

char inputBuffer[20];
int bufferIndex = 0;

char loggedUser[20];

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
    for (i = 0; i < numUsers; i++)
    {
        if (strcmp(users[i].username, inputBuffer) == 0)
        {
            send_string("\nEnter Password: ");
            return;
        }
    }

    // If username not found, register new user
    send_string("\nNew Password: ");
}

void check_password()
{
    int i;
    for (i = 0; i < numUsers; i++)
    {
        if (strcmp(users[i].username, inputBuffer) == 0)
        {
            if (strcmp(users[i].password, inputBuffer) == 0)
            {
                strcpy(loggedUser, users[i].username);
                LED2 = 1; // Turn on the LED2
                send_string("\nLogin Successful!\n");
                return;
            }
        }
    }
    send_string("\nLogin Failed!\n");
    LED2 = 0; // Turn off the LED2
}

interrupt [USART0_RXC] void usart_rx_isr(void)
{
    char data = UDR0;
    if (data == '\n')
    {
        inputBuffer[bufferIndex] = '\0'; // Null-terminate the received string
        if (loggedUser[0] == '\0')
        {
            check_user();
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
