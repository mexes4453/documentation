#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>


int main(void)
{
	int	p[2];
	int	pid1; 
	int	pid2; 

	printf("Starting Main Prog...\n");
	if (pipe(p) < 0)
	{
		write(2, strerror(errno), strlen(strerror(errno)));
		exit(1);
	}
	printf("Pipe creation: ok...\n");
	
	pid1 = fork();
	if (pid1 == 0)
	{
		dup2(p[1], STDOUT_FILENO);
		close(p[1]);
		close(p[0]);
		execlp("ls", "ls", NULL);
		printf("Child process execution: ok...\n");
	}
	waitpid(pid1, NULL, 0);

	pid2 = fork();
	if (pid2 == 0)
	{
		dup2(p[0], STDIN_FILENO);
		close(p[0]);
		close(p[1]);
		execlp("grep", "grep", "Do", NULL);
	}
	close(p[0]);
	close(p[1]);
	waitpid(pid2, NULL, 0);

	printf("Exiting Main Prog...\n");
	return (0);

}

