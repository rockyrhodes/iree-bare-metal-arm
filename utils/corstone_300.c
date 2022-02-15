// Copyright 2022 Fraunhofer-Gesellschaft zur Förderung der angewandten
//                Forschung e.V.
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

// #include <errno.h>
// #include <stdint.h>
// #include <unistd.h>

#include <stdio.h>
#include "uart_stdout.h"

#define STDIN  0x00
#define STDOUT 0x01
#define STDERR 0x02

void clock_setup(void) {
}

void gpio_setup(void) {
}

void usart_setup(void) {
  UartStdOutInit();
}
