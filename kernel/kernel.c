// kernel/kernel.c
void kmain(void) {
    char *video_memory = (char *)0xb8000;
    const char *message = "Bienvenue dans le kernel de NagamOS!";
    int i = 0;

    while (message[i]) {
        video_memory[i * 2] = message[i];
        video_memory[i * 2 + 1] = 0x0F; // couleur blanc sur noir
        i++;
    }

    for (;;) {} // boucle infinie
}
