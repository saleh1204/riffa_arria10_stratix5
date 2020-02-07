// ----------------------------------------------------------------------
// Copyright (c) 2016, The Regents of the University of California All
// rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//
//     * Neither the name of The Regents of the University of California
//       nor the names of its contributors may be used to endorse or
//       promote products derived from this software without specific
//       prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL REGENTS OF THE
// UNIVERSITY OF CALIFORNIA BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
// OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
// TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.
// ----------------------------------------------------------------------
#include <stdlib.h>
#include <stdio.h>
#include "timer.h"
#include "riffa.h"
#include <stdint.h>
#include "time.h"
#include <math.h>
// #include "align_functions.h"
#include <omp.h>

int randInRange(int min, int max)
{
	double scale = 1.0 / (RAND_MAX);
	double range = max - min + 1;
	return min + (int)(rand() * scale * range);
}
uint32_t randomInt()
{
	return (uint32_t)randInRange(0, 0xFFFFFFFF);
}

int main(int argc, char **argv)
{
	fpga_t *fpga;
	fpga_info_list info;
	int option;
	int i;
	int id;
	int chnl;
	size_t numWords;
	int sent;
	int recvd;

	GET_TIME_INIT(3);

	if (argc < 2)
	{
		printf("Usage: %s <option>\n", argv[0]);
		return -1;
	}

	option = atoi(argv[1]);

	if (option == 0)
	{ // List FPGA info
		// Populate the fpga_info_list struct
		if (fpga_list(&info) != 0)
		{
			printf("Error populating fpga_info_list\n");
			return -1;
		}
		printf("Number of devices: %d\n", info.num_fpgas);
		for (i = 0; i < info.num_fpgas; i++)
		{
			printf("%d: id:%d\n", i, info.id[i]);
			printf("%d: num_chnls:%d\n", i, info.num_chnls[i]);
			printf("%d: name:%s\n", i, info.name[i]);
			printf("%d: vendor id:%04X\n", i, info.vendor_id[i]);
			printf("%d: device id:%04X\n", i, info.device_id[i]);
		}
	}
	else if (option == 1)
	{ // Reset FPGA
		if (argc < 3)
		{
			printf("Usage: %s %d <fpga id>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);

		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}

		// Reset
		fpga_reset(fpga);

		// Done with device
		fpga_close(fpga);
	}
	else if (option == 2)
	{ // Send data, receive data
		unsigned int *sendBuffer;
		unsigned int *recvBuffer;
		if (argc < 5)
		{
			printf("Usage: %s %d <fpga id> <chnl> <num words to transfer>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);
		chnl = atoi(argv[3]);
		numWords = atoi(argv[4]);

		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}

		// Malloc the arrays
		sendBuffer = (unsigned int *)malloc((numWords << 2));
		if (sendBuffer == NULL)
		{
			printf("Could not malloc memory for sendBuffer\n");
			fpga_close(fpga);
			return -1;
		}
		recvBuffer = (unsigned int *)malloc((numWords << 2));
		if (recvBuffer == NULL)
		{
			printf("Could not malloc memory for recvBuffer\n");
			free(sendBuffer);
			fpga_close(fpga);
			return -1;
		}

		// Initialize the data
		// generating encryption key
		srand(time(NULL));
		//		for (i = 0; i < 4; i++)
		//		{
		//			sendBuffer[i] = 4 - i;
		//			recvBuffer[i] = 0;
		//		}

		for (i = 0; i < numWords; i++)
		{
			sendBuffer[i] = (i + 1); //randomInt(); //i + 1;
			recvBuffer[i] = 0;
		}
		printf("Done Initialization\n");

		// Send the data
		GET_TIME_VAL(0);
		sent = fpga_send(fpga, chnl, sendBuffer, numWords, 0, 1, 0);
		GET_TIME_VAL(1);
		printf("words sent: %d\n", sent);
		if (sent != 0)
		{
			// Recv the data
			GET_TIME_VAL(2);
			recvd = fpga_recv(fpga, chnl, recvBuffer, numWords, 0);
			GET_TIME_VAL(3);
			printf("words recv: %d\n", recvd);
		}

		// Done with device
		fpga_close(fpga);

		// Display some data
		for (i = 0; i < numWords; i++)
		{
			printf("recvBuffer[%2d]: 0x%08x\tsendBuffer[%2d]: 0x%08x\n", i, recvBuffer[i], i, sendBuffer[i]);
		}

		// Check the data
		int error = 0;
		printf("Error Data:\n");
		if (recvd != 0)
		{
			for (i = 0; i < numWords; i++)
			{
				if (recvBuffer[i] != sendBuffer[i])
				{
					//printf("recvBuffer[%d]: 0x%08x, expected 0x%08x\n", i, recvBuffer[i], sendBuffer[i]);
					// break;
					error++;
				}
			}
			printf("Error: %d out of %d\n", error, recvd);
			printf("Correct Percentage %.2f%%\n", 100.0 * (recvd - error) / (recvd));

			printf("send bw: %f MB/s %fms\n",
				   sent * 4.0 / 1024 / 1024 / ((TIME_VAL_TO_MS(1) - TIME_VAL_TO_MS(0)) / 1000.0),
				   (TIME_VAL_TO_MS(1) - TIME_VAL_TO_MS(0)));

			printf("recv bw: %f MB/s %fms\n",
				   recvd * 4.0 / 1024 / 1024 / ((TIME_VAL_TO_MS(3) - TIME_VAL_TO_MS(2)) / 1000.0),
				   (TIME_VAL_TO_MS(3) - TIME_VAL_TO_MS(2)));
		}
	}
	else if (option == 3)
	{
		unsigned int *sendBuffer;
		unsigned int *recvBuffer;
		// Send data, receive data as multiple of transfer_size words (ints)
		if (argc < 6)
		{
			printf("Usage: %s %d <fpga id> <chnl> <num words to transfer> <transfer_size in words>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);
		chnl = atoi(argv[3]);
		numWords = atoi(argv[4]);
		int transferSize = atoi(argv[5]);
		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}

		// Malloc the arrays
		sendBuffer = (unsigned int *)malloc((numWords << 2));
		if (sendBuffer == NULL)
		{
			printf("Could not malloc memory for sendBuffer\n");
			fpga_close(fpga);
			return -1;
		}
		recvBuffer = (unsigned int *)malloc((numWords << 2));
		if (recvBuffer == NULL)
		{
			printf("Could not malloc memory for recvBuffer\n");
			free(sendBuffer);
			fpga_close(fpga);
			return -1;
		}

		// Initialize the data
		srand(time(NULL));
		double sending_time = 0, receiving_time = 0;

		for (i = 0; i < numWords; i++)
		{
			sendBuffer[i] = i; //randomInt();
			recvBuffer[i] = 0;
		}
		printf("Done Initialization\n");
		int words_sent = 0, words_received = 0;
		i = 0;
		sent = 0;
		recvd = 0;
		double start = 0, end = 0;
		int last;
		// Send the data
		for (words_sent = 0; words_sent < numWords;)
		{
			int temp;
			if (numWords - words_sent >= transferSize)
			{
				temp = transferSize;
			}
			else
			{
				temp = numWords - words_sent;
			}
			last = (temp + words_sent) == numWords;
			// printf("last: %d \n", last);
			// printf("Stage: %d Sending \n", i);
			// GET_TIME_VAL(0);
			start = omp_get_wtime();
			sent = fpga_send(fpga, chnl, &sendBuffer[words_sent], temp, 0, last, 30000);
			end = omp_get_wtime();
			// GET_TIME_VAL(1);
			sending_time += (end - start);
			words_sent += sent;
			// printf("Stage: %d Receiving \n", i);
			// GET_TIME_VAL(2);
			start = omp_get_wtime();
			recvd = fpga_recv(fpga, chnl, &recvBuffer[words_received], temp, 30000);
			end = omp_get_wtime();
			// GET_TIME_VAL(3);
			receiving_time += (end - start);
			words_received += recvd;
			if (sent == 0)
			{
				printf("Could not send \t quitting \n");
				//				break;
			}
			if (recvd == 0)
			{
				printf("Could not receive \t quitting \n");
				//				break;
			}
			i++;
		}
		printf("words sent: %d in %d stages \n", words_sent, i);
		printf("words recv: %d in %d stages \n", words_received, i);

		// Done with device
		fpga_close(fpga);

		// Display some data
		// for (i = 0; i < numWords; i++)
		// {
		// 	printf("recvBuffer[%2d]: 0x%08x\tsendBuffer[%2d]: 0x%08x\n", i, recvBuffer[i], i, sendBuffer[i]);
		// }

		// Check the data
		int error = 0;
		if (recvd != 0)
		{
			for (i = 0; i < numWords; i++)
			{
				if (recvBuffer[i] != sendBuffer[i])
				{
					printf("recvBuffer[%d]: 0x%08x, expected 0x%08x\n", i, recvBuffer[i], sendBuffer[i]);
					// break;
					error++;
				}
			}
			printf("Error: %d out of %d\n", error, words_received);
			printf("Correct Percentage %.2f%%\n", 100.0 * (words_received - error) / (words_received));

			printf("send bw: %f MB/s %fms\n",
				   words_sent * 4.0 / 1024 / 1024 / ((sending_time)),
				   (sending_time * 1000));

			printf("recv bw: %f MB/s %fms\n",
				   words_received * 4.0 / 1024 / 1024 / ((receiving_time)),
				   (receiving_time * 1000));
		}
	}
	else if (option == 4)
	{

		// Send data, receive data as multiple of transfer_size words (ints)
		if (argc < 6)
		{
			printf("Usage: %s %d <fpga id> <chnl> <num words to transfer> <transfer_size in words>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);
		chnl = atoi(argv[3]);
		numWords = atoi(argv[4]);
		int transferSize = atoi(argv[5]);
		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}
		// reseting fpga
		fpga_reset(fpga);
		unsigned int *sendBuffer;
		unsigned int *sendBuffer_32bit_aligned;
		unsigned int *recvBuffer;
		unsigned int *recvBuffer_32bit_aligned;
		// int sendBuffer[64 + 1];
		// int recvBuffer[64 + 1];
		// Malloc the arrays
		sendBuffer = (unsigned int *)malloc((numWords << 2));
		// sendBuffer = (unsigned int *)aligned_malloc(((numWords + 1) << 2), 4);
		if (sendBuffer == NULL)
		{
			printf("Could not malloc memory for sendBuffer\n");
			fpga_close(fpga);
			return -1;
		}
		sendBuffer_32bit_aligned = (unsigned int *)sendBuffer + 0;
		recvBuffer = (unsigned int *)malloc((numWords << 2));
		// recvBuffer = (unsigned int *)aligned_malloc(((numWords + 1) << 2), 4);
		if (recvBuffer == NULL)
		{
			printf("Could not malloc memory for recvBuffer\n");
			free(sendBuffer);
			fpga_close(fpga);
			return -1;
		}
		recvBuffer_32bit_aligned = (unsigned int *)recvBuffer + 0;

		printf("sizeof(int): %lu bytes\n", sizeof(int));
		printf("sizeof(long): %lu bytes\n", sizeof(long));
		printf("sendBuffer pointer: %p \n", sendBuffer);
		printf("sendBuffer_32bit_aligned pointer: %p \n", sendBuffer_32bit_aligned);
		printf("recvBuffer pointer: %p \n", recvBuffer);
		printf("recvBuffer_32bit_aligned pointer: %p \n", recvBuffer_32bit_aligned);
		// Initialize the data
		srand(time(NULL));
		double sending_time = 0, receiving_time = 0;
		uint8_t counter;
		for (i = 0; i < numWords; i++)
		{
			counter = i & 0xFF;
			sendBuffer_32bit_aligned[i] = (counter << 24) | (counter << 16) | (counter << 8) | (counter);
			recvBuffer_32bit_aligned[i] = 0;
		}
		printf("Done Initialization\n");
		int words_sent = 0, words_received = 0;
		i = 0;
		sent = 0;
		recvd = 0;
		int last;
		double start = 0, end = 0;
		// Send the data
		for (words_sent = 0; words_sent < numWords;)
		{
			int temp;
			if (numWords - words_sent >= transferSize)
			{
				temp = transferSize;
			}
			else
			{
				temp = numWords - words_sent;
			}
			last = (temp + words_sent) == numWords;
			// last = 1;
			printf("last: %d \n", last);
			// printf("Stage: %d Sending \n", i);
			// GET_TIME_VAL(0);
			start = omp_get_wtime();
			sent = fpga_send(fpga, chnl, &sendBuffer_32bit_aligned[words_sent], temp, 0, last, 30000);
			end = omp_get_wtime();
			// GET_TIME_VAL(1);
			sending_time += (end - start);
			words_sent += sent;
			// printf("Stage: %d Receiving \n", i);
			// GET_TIME_VAL(2);
			start = omp_get_wtime();
			recvd = fpga_recv(fpga, chnl, &recvBuffer_32bit_aligned[words_received], temp, 30000);
			end = omp_get_wtime();
			// GET_TIME_VAL(3);
			receiving_time += (end - start);
			words_received += recvd;
			if (sent == 0)
			{
				printf("Could not send \t  \n");
				//				break;
			}
			if (recvd == 0)
			{
				printf("Could not receive \t  \n");
				//				break;
			}
			i++;
		}
		printf("words sent: %d in %d stages \n", words_sent, i);
		printf("words recv: %d in %d stages \n", words_received, i);
		int abs_byte0, abs_byte1, abs_byte2, abs_byte3;
		// Done with device
		fpga_close(fpga);
		int error = 0;
		if (recvd != 0)
		{
			for (i = 0; i < numWords; i++)
			{
				//				abs_byte0 = (0xFF & ( (recvBuffer_32bit_aligned[i-1] & 0xFF) + 1) )        == ( recvBuffer_32bit_aligned[i] & 0xFF);
				//				abs_byte1 = (0xFF & ( (recvBuffer_32bit_aligned[i-1] >> 8  & 0xFF) + 1 ) ) == ( recvBuffer_32bit_aligned[i] >> 8  & 0xFF);
				//				abs_byte2 = (0xFF & ( (recvBuffer_32bit_aligned[i-1] >> 16 & 0xFF) + 1 ) ) == ( recvBuffer_32bit_aligned[i] >> 16 & 0xFF);
				//				abs_byte3 = (0xFF & ( (recvBuffer_32bit_aligned[i-1] >> 24 & 0xFF) + 1 ) ) == ( recvBuffer_32bit_aligned[i] >> 24 & 0xFF);
				if (recvBuffer_32bit_aligned[i] != sendBuffer_32bit_aligned[i])
				{
					printf("*****************Error at word %d*******************\n", i);
					if ((i - 3) >= 0)
					{
						printf("recvBuffer[%d]: 0x%08x, sendBuffer[%d] 0x%08x\n", i - 3, recvBuffer_32bit_aligned[i - 3], i - 3, sendBuffer_32bit_aligned[i - 3]);
					}
					if ((i - 2) >= 0)
					{
						printf("recvBuffer[%d]: 0x%08x, sendBuffer[%d] 0x%08x\n", i - 2, recvBuffer_32bit_aligned[i - 2], i - 2, sendBuffer_32bit_aligned[i - 2]);
					}
					if ((i - 1) >= 0)
					{
						printf("recvBuffer[%d]: 0x%08x, sendBuffer[%d] 0x%08x\n", i - 1, recvBuffer_32bit_aligned[i - 1], i - 1, sendBuffer_32bit_aligned[i - 1]);
					}
					printf("recvBuffer[%d]: 0x%08x, sendBuffer[%d] 0x%08x\n", i, recvBuffer_32bit_aligned[i], i, sendBuffer_32bit_aligned[i]);
					if ((i + 1) < numWords)
					{
						printf("recvBuffer[%d]: 0x%08x, sendBuffer[%d] 0x%08x\n", i + 1, recvBuffer_32bit_aligned[i + 1], i + 1, sendBuffer_32bit_aligned[i + 1]);
					}
					if ((i + 2) < numWords)
					{
						printf("recvBuffer[%d]: 0x%08x, sendBuffer[%d] 0x%08x\n", i + 2, recvBuffer_32bit_aligned[i + 2], i + 2, sendBuffer_32bit_aligned[i + 2]);
					}
					if ((i + 3) < numWords)
					{
						printf("recvBuffer[%d]: 0x%08x, sendBuffer[%d] 0x%08x\n", i + 3, recvBuffer_32bit_aligned[i + 3], i + 3, sendBuffer_32bit_aligned[i + 3]);
					}
					printf("****************************************************\n");
					error++;
				}
			}
			printf("Incorrectly Received Words: %d out of %d\n", error, words_received);
			printf("Correct Percentage %.2f%%\n", 100.0 * (words_received - error) / (words_received));

			printf("send bw: %f MB/s %fms\n",
				   words_sent * 4.0 / 1024 / 1024 / ((sending_time)),
				   (sending_time * 1000));

			printf("recv bw: %f MB/s %fms\n",
				   words_received * 4.0 / 1024 / 1024 / ((receiving_time)),
				   (receiving_time * 1000));
		}
		// free(sendBuffer);
		// free(recvBuffer);
	}
	else if (option == 5)
	{
		unsigned int *sendBuffer;
		unsigned int *recvBuffer;
		unsigned int *expected_results;
		// Send data, receive data as multiple of transfer_size words (ints)
		if (argc < 6)
		{
			printf("Usage: %s %d <fpga id> <chnl> <num words to transfer> <transfer_size in words>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);
		chnl = atoi(argv[3]);
		numWords = atoi(argv[4]);
		int transferSize = atoi(argv[5]);
		int numberOfChunks = (int)ceil((1.0 * numWords) / transferSize);
		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}
		// reseting fpga
		//fpga_reset(fpga);

		// Malloc the arrays
		sendBuffer = (unsigned int *)malloc((numWords << 2));
		if (sendBuffer == NULL)
		{
			printf("Could not malloc memory for sendBuffer\n");
			fpga_close(fpga);
			return -1;
		}
		recvBuffer = (unsigned int *)malloc(numberOfChunks * 16);
		if (recvBuffer == NULL)
		{
			printf("Could not malloc memory for recvBuffer\n");
			free(sendBuffer);
			fpga_close(fpga);
			return -1;
		}
		expected_results = (unsigned int *)malloc(numberOfChunks * 16);
		if (expected_results == NULL)
		{
			printf("Could not malloc memory for expected_results\n");
			free(sendBuffer);
			free(recvBuffer);
			fpga_close(fpga);
			return -1;
		}

		// Initialize the data
		srand(time(NULL));
		double sending_time = 0, receiving_time = 0;
		int counter0 = 0, counter1 = 1, counter2 = 2, counter3 = 3;
		//		unsigned int expected_result0 = 0, expected_result1 = 0, expected_result2 = 0, expected_result3 = 0;
		for (i = 0; i < numberOfChunks * 4; i++)
		{
			recvBuffer[i] = 0;
			expected_results[i] = 0;
		}

		for (i = 0; i < numWords;)
		{
			sendBuffer[i + 0] = counter0;
			sendBuffer[i + 1] = counter1;
			sendBuffer[i + 2] = counter2;
			sendBuffer[i + 3] = counter3;
			expected_results[4 * (i / transferSize) + 0] += counter0;
			expected_results[4 * (i / transferSize) + 1] += counter1;
			expected_results[4 * (i / transferSize) + 2] += counter2;
			expected_results[4 * (i / transferSize) + 3] += counter3;
			counter0 = counter0 + 1;
			counter1 = counter1 + 2;
			counter2 = counter2 + 3;
			counter3 = counter3 + 4;
			i = i + 4;
		}
		//		printf("Expected Result[0]: %08x\n", expected_result0);
		//		printf("Expected Result[1]: %08x\n", expected_result1);
		//		printf("Expected Result[2]: %08x\n", expected_result2);
		//		printf("Expected Result[3]: %08x\n", expected_result3);
		printf("Done Initialization\n");
		int words_sent = 0, words_received = 0;
		i = 0;
		sent = 0;
		recvd = 0;
		int last;
		// Send the data
		for (words_sent = 0; words_sent < numWords;)
		{
			int temp;
			if (numWords - words_sent >= transferSize)
			{
				temp = transferSize;
			}
			else
			{
				temp = numWords - words_sent;
			}
			last = (temp + words_sent) == numWords;
			// printf("last: %d \n", last);
			// printf("Stage: %d Sending \n", i);
			GET_TIME_VAL(0);
			sent = fpga_send(fpga, chnl, &sendBuffer[words_sent], temp, 0, last, 30000);
			GET_TIME_VAL(1);
			sending_time += (TIME_VAL_TO_MS(1) - TIME_VAL_TO_MS(0));
			words_sent += sent;
			// printf("Stage: %d Receiving \n", i);
			GET_TIME_VAL(2);
			recvd = fpga_recv(fpga, chnl, &recvBuffer[words_received], 4, 30000);
			GET_TIME_VAL(3);
			receiving_time += TIME_VAL_TO_MS(3) - TIME_VAL_TO_MS(2);
			words_received += recvd;
			if (sent == 0)
			{
				printf("Could not send \t quitting \n");
				break;
			}
			if (recvd == 0)
			{
				printf("Could not receive \t quitting \n");
				break;
			}
			i++;
		}
		printf("words sent: %d in %d stages \n", words_sent, i);
		printf("words recv: %d in %d stages \n", words_received, i);
		// Done with device
		fpga_close(fpga);

		// Check the data
		int error = 0;
		if (recvd != 0)
		{
			for (i = 0; i < numberOfChunks * 4; i++)
			{
				printf("recvBuffer[%d]: %08x\t", i, recvBuffer[i]);
				printf("expected_results[%d]: %08x\n", i, expected_results[i]);
			}
			printf("send bw: %f MB/s %fms\n",
				   words_sent * 4.0 / 1024 / 1024 / ((sending_time) / 1000.0),
				   (sending_time));

			printf("recv bw: %f MB/s %fms\n",
				   words_received * 4.0 / 1024 / 1024 / ((receiving_time) / 1000.0),
				   (receiving_time));
		}
	}
	else if (option == 6)
	{
		unsigned int *sendBuffer;
		unsigned int *recvBuffer;
		unsigned int *expected_results;
		// Send data, receive data as multiple of transfer_size words (ints)
		if (argc < 6)
		{
			printf("Usage: %s %d <fpga id> <chnl> <num words to transfer> <transfer_size in words>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);
		chnl = atoi(argv[3]);
		numWords = atoi(argv[4]);
		int transferSize = atoi(argv[5]);
		int numberOfChunks = (int)ceil((1.0 * numWords) / transferSize);
		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}
		// reseting fpga
		//fpga_reset(fpga);

		// Malloc the arrays
		sendBuffer = (unsigned int *)malloc((numWords << 2));
		if (sendBuffer == NULL)
		{
			printf("Could not malloc memory for sendBuffer\n");
			fpga_close(fpga);
			return -1;
		}
		recvBuffer = (unsigned int *)malloc((numWords << 2));
		if (recvBuffer == NULL)
		{
			printf("Could not malloc memory for recvBuffer\n");
			free(sendBuffer);
			fpga_close(fpga);
			return -1;
		}
		expected_results = (unsigned int *)malloc((numWords << 2));
		if (expected_results == NULL)
		{
			printf("Could not malloc memory for expected_results\n");
			free(sendBuffer);
			free(recvBuffer);
			fpga_close(fpga);
			return -1;
		}

		// Initialize the data
		srand(time(NULL));
		double sending_time = 0, receiving_time = 0;
		int counter0 = 0, counter1 = 1, counter2 = 2, counter3 = 3;
		//		unsigned int expected_result0 = 0, expected_result1 = 0, expected_result2 = 0, expected_result3 = 0;
		for (i = 0; i < numberOfChunks * 4; i++)
		{
			recvBuffer[i] = 0;
			expected_results[i] = 0;
		}

		for (i = 0; i < numWords;)
		{
			sendBuffer[i + 0] = counter0;
			sendBuffer[i + 1] = counter1;
			sendBuffer[i + 2] = counter2;
			sendBuffer[i + 3] = counter3;
			if (i >= 4)
			{
				expected_results[i + 0] = expected_results[i - 4] + counter0;
				expected_results[i + 1] = expected_results[i - 3] + counter1;
				expected_results[i + 2] = expected_results[i - 2] + counter2;
				expected_results[i + 3] = expected_results[i - 1] + counter3;
			}
			else
			{
				expected_results[i + 0] = counter0;
				expected_results[i + 1] = counter1;
				expected_results[i + 2] = counter2;
				expected_results[i + 3] = counter3;
			}

			counter0 = counter0 + 1;
			counter1 = counter1 + 2;
			counter2 = counter2 + 3;
			counter3 = counter3 + 4;
			i = i + 4;
		}
		printf("Done Initialization\n");
		int words_sent = 0, words_received = 0;
		i = 0;
		sent = 0;
		recvd = 0;
		int last;
		double start = 0, end = 0;
		// Send & receive the data
		for (words_sent = 0; words_sent < numWords;)
		{
			int temp;
			if (numWords - words_sent >= transferSize)
			{
				temp = transferSize;
			}
			else
			{
				temp = numWords - words_sent;
			}
			last = (temp + words_sent) == numWords;

			start = omp_get_wtime();
			sent = fpga_send(fpga, chnl, &sendBuffer[words_sent], temp, 0, last, 30000);
			end = omp_get_wtime();

			sending_time += (end - start);
			words_sent += sent;

			start = omp_get_wtime();
			recvd = fpga_recv(fpga, chnl, &recvBuffer[words_received], temp, 30000);
			end = omp_get_wtime();
			receiving_time += (end - start);
			words_received += recvd;
			if (sent == 0)
			{
				printf("Could not send \t quitting \n");
				break;
			}
			if (recvd == 0)
			{
				printf("Could not receive \t quitting \n");
				break;
			}
			i++;
		}
		printf("words sent: %d in %d stages \n", words_sent, i);
		printf("words recv: %d in %d stages \n", words_received, i);
		// Done with device
		fpga_close(fpga);

		// Check the data
		int error = 0;
		if (recvd != 0)
		{
			for (i = 0; i < numWords; i++)
			{
				printf("sendBuffer[%04d]: %08x\t", i, sendBuffer[i]);
				printf("recvBuffer[%04d]: %08x\t", i, recvBuffer[i]);
				printf("expected_results[%04d]: %08x\n", i, expected_results[i]);
				if (expected_results[i] != recvBuffer[i])
					error++;
			}
			printf("Incorrect Words: %d \n", error);
			printf("send bw: %f MB/s %fms\n", words_sent * 4.0 / 1024 / 1024 / ((sending_time)), (sending_time * 1000));

			printf("recv bw: %f MB/s %fms\n", words_received * 4.0 / 1024 / 1024 / ((receiving_time)), (receiving_time * 1000));
		}
	}
	else if (option == 7) // compression emulation (Saleh's Channel)
	{

		// Send data, receive data as multiple of transfer_size words (ints)
		if (argc < 7)
		{
			printf("Usage: %s %d <fpga id> <chnl> <num words to transfer> <transfer_size in words> <COMPRESSION_RATIO>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);
		chnl = atoi(argv[3]);
		numWords = atoi(argv[4]);
		int transferSize = atoi(argv[5]);
		int original_compressiosn_ratio = atoi(argv[6]);
		int compression_ratio = 1 << (int)ceil(log2f(original_compressiosn_ratio));
		printf("Compression Ratio %d\n", compression_ratio);
		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}
		// reseting fpga
		fpga_reset(fpga);
		unsigned int *sendBuffer;
		unsigned int *recvBuffer;
		unsigned int *expectedResult;

		// Malloc the arrays
		sendBuffer = (unsigned int *)malloc((numWords << 2));
		// sendBuffer = (unsigned int *)aligned_malloc(((numWords + 1) << 2), 4);
		if (sendBuffer == NULL)
		{
			printf("Could not malloc memory for sendBuffer\n");
			fpga_close(fpga);
			return -1;
		}
		recvBuffer = (unsigned int *)malloc((numWords << 2) / compression_ratio);
		// recvBuffer = (unsigned int *)aligned_malloc(((numWords + 1) << 2), 4);
		if (recvBuffer == NULL)
		{
			printf("Could not malloc memory for recvBuffer\n");
			free(sendBuffer);
			fpga_close(fpga);
			return -1;
		}
		expectedResult = (unsigned int *)malloc((numWords << 2) / compression_ratio);
		// recvBuffer = (unsigned int *)aligned_malloc(((numWords + 1) << 2), 4);
		if (expectedResult == NULL)
		{
			printf("Could not malloc memory for expectedResult\n");
			free(sendBuffer);
			free(recvBuffer);
			fpga_close(fpga);
			return -1;
		}
		printf("sendBuffer pointer: %p \n", sendBuffer);
		printf("recvBuffer pointer: %p \n", recvBuffer);
		// Initialize the data
		srand(time(NULL));
		double sending_time = 0, receiving_time = 0;
		uint8_t counter;
		uint32_t j = 0;
		for (i = 0; i < numWords; i++)
		{
			counter = i & 0xFF;
			sendBuffer[i] = (counter << 24) | (counter << 16) | (counter << 8) | (counter);
			if (i < (numWords / compression_ratio))
			{
				recvBuffer[i] = 0;
			}
			if ((i != 0))
			{
				if ((i % (4 * original_compressiosn_ratio)) >= ((original_compressiosn_ratio - 1) * 4))
				{
					expectedResult[j] = sendBuffer[i];
					j++;
				}
			}
		}

		printf("Done Initialization\n");
		int words_sent = 0, words_received = 0;
		i = 0;
		sent = 0;
		recvd = 0;
		int last;
		double start = 0, end = 0;
		// Send the data
		for (words_sent = 0; words_sent < numWords;)
		{
			int temp;
			if (numWords - words_sent >= transferSize)
			{
				temp = transferSize;
			}
			else
			{
				temp = numWords - words_sent;
			}
			last = (temp + words_sent) == numWords;
			// last = 1;
			printf("last: %d \n", last);
			// printf("Stage: %d Sending \n", i);
			// GET_TIME_VAL(0);
			start = omp_get_wtime();
			sent = fpga_send(fpga, chnl, &sendBuffer[words_sent], temp, 0, last, 30000);
			end = omp_get_wtime();
			// GET_TIME_VAL(1);
			sending_time += (end - start);
			words_sent += sent;
			// printf("Stage: %d Receiving \n", i);
			// GET_TIME_VAL(2);
			start = omp_get_wtime();
			recvd = fpga_recv(fpga, chnl, &recvBuffer[words_received], (temp / compression_ratio), 30000);
			end = omp_get_wtime();
			// GET_TIME_VAL(3);
			receiving_time += (end - start);
			words_received += recvd;
			if (sent == 0)
			{
				printf("Could not send \t  \n");
				break;
			}
			if (recvd == 0)
			{
				printf("Could not receive \t  \n");
				break;
			}
			i++;
		}
		int error = 0;
		for (j = 0; j < numWords / compression_ratio; j++)
		{
			if (recvBuffer[j] != expectedResult[j])
			{
				//printf("Error at %d, recvBuffer = %08x, expectedResult = %08x\n", j, recvBuffer[j], expectedResult[j]);
				error++;
			}
		}
		printf("Total Number of errors: %d\n", error);
		printf("words sent: %d in %d stages \n", words_sent, i);
		printf("words recv: %d in %d stages \n", words_received, i);

		// Done with device
		fpga_close(fpga);

		printf("send bw: %f MB/s %fms\n",
			   words_sent * 4.0 / 1024 / 1024 / ((sending_time)),
			   (sending_time * 1000));

		printf("recv bw: %f MB/s %fms\n",
			   words_received * 4.0 / 1024 / 1024 / ((receiving_time)),
			   (receiving_time * 1000));

		// free(sendBuffer);
		// free(recvBuffer);
	}
	else if (option == 8) // compression emulation (Dr. ElRabaa's Channel)
	{

		// Send data, receive data as multiple of transfer_size words (ints)
		if (argc < 8)
		{
			printf("Usage: %s %d <fpga id> <chnl> <num words to transfer> <transfer_size in words> <COMPRESSION_NUM[M]> <COMPRESSION_DEN[N]>\n", argv[0], option);
			return -1;
		}

		id = atoi(argv[2]);
		chnl = atoi(argv[3]);
		numWords = atoi(argv[4]);
		int transferSize = atoi(argv[5]);
		int compression_num = atoi(argv[6]); // M
		int compression_den = atoi(argv[7]); // N
		// Get the device with id
		fpga = fpga_open(id);
		if (fpga == NULL)
		{
			printf("Could not get FPGA %d\n", id);
			return -1;
		}
		// reseting fpga
		fpga_reset(fpga);
		float *sendBuffer;
		float *recvBuffer;

		// Malloc the arrays
		sendBuffer = (float *)malloc((numWords << 2));
		if (sendBuffer == NULL)
		{
			printf("Could not malloc memory for sendBuffer\n");
			fpga_close(fpga);
			return -1;
		}
		recvBuffer = (float *)malloc((compression_num * (numWords << 2)) >> (compression_den + 1));
		if (recvBuffer == NULL)
		{
			printf("Could not malloc memory for recvBuffer\n");
			free(sendBuffer);
			fpga_close(fpga);
			return -1;
		}
		printf("sendBuffer pointer: %p \n", sendBuffer);
		printf("recvBuffer pointer: %p \n", recvBuffer);
		// Initialize the data
		srand(time(NULL));
		double sending_time = 0, receiving_time = 0;
		uint8_t compression_byte;
		compression_byte = ((compression_num << 3) | (compression_den)) & 0xFF;
		uint32_t j = 0;
		uint8_t counter;
		for (i = 0; i < numWords; i++)
		{
			counter = i & 0xFF;
			if (i == 0)
			{
				*(int*)&sendBuffer[i] = (compression_byte << 24) | (compression_byte << 16) | (compression_byte << 8) | (compression_byte);
				int tmp = *(int*)&sendBuffer[i];
				printf("sendBuffer[%d]= %f (as float) %d (as integer) %08x (as hex)\n", i, sendBuffer[i], tmp, tmp);
			}
			else
			{

				sendBuffer[i] = (counter << 24) | (counter << 16) | (counter << 8) | (counter);
			}
			if (i < ((compression_num * numWords) >> (compression_den + 1)))
			{
				recvBuffer[i] = 0;
			}
		}

		printf("Done Initialization\n");
		int words_sent = 0, words_received = 0;
		i = 0;
		sent = 0;
		recvd = 0;
		int last;
		double start = 0, end = 0;
		int temp_recv = 0;
		// Send the data
		for (words_sent = 0; words_sent < numWords;)
		{
			int temp;
			if (numWords - words_sent >= transferSize)
			{
				temp = transferSize;
			}
			else
			{
				temp = numWords - words_sent;
			}
			last = (temp + words_sent) == numWords;
			printf("last: %d \n", last);
			start = omp_get_wtime();
			sent = fpga_send(fpga, chnl, &sendBuffer[words_sent], temp, 0, last, 30000);
			end = omp_get_wtime();
			sending_time += (end - start);
			words_sent += sent;
			temp_recv = (compression_num * temp) >> (1 + compression_den);
			start = omp_get_wtime();
			recvd = fpga_recv(fpga, chnl, &recvBuffer[words_received], temp_recv, 30000);
			end = omp_get_wtime();
			receiving_time += (end - start);
			words_received += recvd;
			if (sent == 0)
			{
				printf("Could not send \t  \n");
				break;
			}
			if (recvd == 0)
			{
				printf("Could not receive \t  \n");
				break;
			}
			i++;
		}
		printf("words sent: %d in %d stages \n", words_sent, i);
		printf("words recv: %d in %d stages \n", words_received, i);

		// Done with device
		fpga_close(fpga);

		printf("send bw: %f MB/s %fms\n",
			   words_sent * 4.0 / 1024 / 1024 / ((sending_time)),
			   (sending_time * 1000));

		printf("recv bw: %f MB/s %fms\n",
			   words_received * 4.0 / 1024 / 1024 / ((receiving_time)),
			   (receiving_time * 1000));
	}

	return 0;
}
