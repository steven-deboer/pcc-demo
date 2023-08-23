import curses
import math
import time
import sys
import subprocess

verbose_mode = False

def help_learning_phase():
    try:
        cmd_output = subprocess.check_output("echo test 2>&1 >/dev/null", stderr=subprocess.STDOUT, shell=True, text=True).strip()
        cmd_output = subprocess.check_output("wget 2>&1 >/dev/null", stderr=subprocess.STDOUT, shell=True, text=True).strip()
    except subprocess.CalledProcessError:
        return False
    return True

def try_write_shadow():
    try:
        with open('/etc/shadow', 'w') as file:
            file.write("# Malicious content")
        status = "Success"
        details = "I was able to execute this attack: writing to /etc/shadow"
    except:
        status = "Stopped"
        details = "Prisma Cloud blocked this attack: writing to /etc/shadow"
    return status, details

def check_passwd():
    try:
        with open('/etc/passwd', 'r') as file:
            cmd_output = file.read()
        status = "Success"
        details = f"I was able to execute this attack: reading /etc/passwd\nAttack output:\n{cmd_output}"
    except:
        status = "Stopped"
        details = "Prisma Cloud blocked this attack: reading /etc/passwd"
    return status, details

def check_whoami():
    try:
        cmd_output = subprocess.check_output("whoami", stderr=subprocess.STDOUT, shell=True, text=True).strip()
        status = "Success"
        details = f"I was able to execute this attack: executing whoami\nAttack output:\n{cmd_output}"
    except subprocess.CalledProcessError:
        status = "Stopped"
        details = "Prisma Cloud blocked this attack: executing whoami"
    return status, details

def download_malware():
    try:
        cmd_output = subprocess.check_output("wget http://wildfire.paloaltonetworks.com/publicapi/test/elf -O /tmp/malware-sample", stderr=subprocess.STDOUT, shell=True, text=True)
        status = "Success"
        details = f"I was able to execute this attack: downloading malware\nAttack output:\n{cmd_output}"
    except subprocess.CalledProcessError:
        status = "Stopped"
        details = "Prisma Cloud blocked this attack: downloading malware"
    return status, details

def simulate_attacks():
    attacks = []
    angle = 0  # Start angle
    attacks.append(("Writing to /etc/shadow", *try_write_shadow(), angle))
    angle += 120  # Increment angle
    attacks.append(("Executing whoami", *check_whoami(), angle))
    angle += 120  # Increment angle
    attacks.append(("Downloading malware", *download_malware(), angle))
    return attacks


def draw_attack_log(stdscr, attacks):
    y_offset = 13 # Changed to move logs further down
    stdscr.addstr(y_offset, 30, "Attack Log", curses.color_pair(2))
    for i, attack in enumerate(attacks):
        color = curses.color_pair(3) if attack[1] == "Stopped" else curses.color_pair(4)
        stdscr.addstr(y_offset + i + 2, 30, f"Attack {i+1}: Type {attack[0]} - {attack[1]}", color)
        if verbose_mode:
            for detail_line in attack[2].split('\n'):
                y_offset += 1
                stdscr.addstr(y_offset + i + 2, 30, detail_line)

def draw_main_info(stdscr):
    stdscr.addstr(2, 30, "Prisma Cloud Attack Simulator", curses.color_pair(2)) # Title updated
    stdscr.addstr(5, 30, "Simulation of Zero-Day Attacks", curses.color_pair(3))
    stdscr.addstr(6, 30, f"Verbose Mode: {'ON' if verbose_mode else 'OFF'}", curses.color_pair(3)) # Verbose status
    stdscr.addstr(7, 30, "Press 'x' to run attacks", curses.color_pair(3))
    stdscr.addstr(8, 30, "Press 'v' to toggle verbose mode", curses.color_pair(3))
    stdscr.addstr(9, 30, "Press 'c' to reset the dashboard", curses.color_pair(3))
    stdscr.addstr(10, 30, "Press 'q' to quit", curses.color_pair(3))


def draw_radar(stdscr, angle, attacks):
    center_x = 10
    center_y = 6
    radar_radius = 4
    max_y, max_x = stdscr.getmaxyx()
    # Clearing the radar area
    for y in range(center_y - radar_radius, center_y + radar_radius + 1):
        for x in range(center_x - radar_radius, center_x + radar_radius + 1):
            if 0 <= y < max_y and 0 <= x < max_x:
                stdscr.addch(y, x, " ")
    # Drawing the radar circle
    for angle_circle in range(360):
        x = int(center_x + radar_radius * math.cos(math.radians(angle_circle)))
        y = int(center_y + radar_radius * math.sin(math.radians(angle_circle)))
        if 0 <= y < max_y and 0 <= x < max_x:
            stdscr.addch(y, x, ".", curses.color_pair(1))
    # Drawing the scanning line
    x = int(center_x + radar_radius * math.cos(math.radians(angle)))
    y = int(center_y + radar_radius * math.sin(math.radians(angle)))
    if 0 <= y < max_y and 0 <= x < max_x:
        if any(attack[1] == "Stopped" and int(attack[3]) == angle for attack in attacks):
            stdscr.addch(y, x, "❌")
        else:
            stdscr.addch(y, x, "🔍", curses.color_pair(1))

def main(stdscr):
    global verbose_mode
    curses.curs_set(0)
    stdscr.clear()
    stdscr.nodelay(1)
    stdscr.timeout(100)
    curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_GREEN)
    curses.init_pair(3, curses.COLOR_GREEN, curses.COLOR_BLACK)
    curses.init_pair(4, curses.COLOR_RED, curses.COLOR_BLACK)

    angle = 0
    attacks = []

    # Run some processes to be added in runtime model
    help_learning_phase()

    while True:
        draw_radar(stdscr, angle, attacks)
        draw_attack_log(stdscr, attacks)
        draw_main_info(stdscr)
        stdscr.refresh()

        key = stdscr.getch()
        if key == ord('x'):
            stdscr.clear()
            attacks = simulate_attacks()
        if key == ord('v'):
            verbose_mode = not verbose_mode
            stdscr.clear()
        if key == ord('c'):
            attacks = []
            stdscr.clear()
        if key == ord('q'):
            sys.exit(0)

        angle = (angle + 10) % 360
        time.sleep(0.1)

curses.wrapper(main)