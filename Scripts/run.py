

import os
import sys
import shutil
import subprocess
from pathlib import Path

# ==========================================================
# Configuration
# ==========================================================

PROJECT_ROOT = Path(__file__).resolve().parent.parent

RTL_DIR = PROJECT_ROOT / "RTL"
TB_DIR = PROJECT_ROOT / "Testbench"

BUILD_DIR = PROJECT_ROOT / "Build"
WAVE_DIR = PROJECT_ROOT / "Waveforms"

TOP_MODULE = "tb_riscv_core"

SIM_OUT = BUILD_DIR / "sim.out"
FILELIST = BUILD_DIR / "filelist.f"
VCD_FILE = WAVE_DIR / "tb_riscv_core.vcd"

# ==========================================================
# Create Required Directories
# ==========================================================

BUILD_DIR.mkdir(exist_ok=True)
WAVE_DIR.mkdir(exist_ok=True)

# ==========================================================
# Clean Previous Build
# ==========================================================

def clean():

    if SIM_OUT.exists():
        SIM_OUT.unlink()

    if FILELIST.exists():
        FILELIST.unlink()

# ==========================================================
# Generate filelist.f
# ==========================================================

def generate_filelist():

    rtl_files = []
    tb_files = []

    # -------------------------
    # RTL
    # -------------------------
    for root, _, files in os.walk(RTL_DIR):

        for file in files:

            if file.endswith(".v"):

                rel = (Path(root) / file).relative_to(PROJECT_ROOT)

                rtl_files.append(
                    str(rel).replace("\\", "/")
                )

    # -------------------------
    # Testbench
    # -------------------------
    for root, _, files in os.walk(TB_DIR):

        for file in files:

            if file.endswith(".v"):

                rel = (Path(root) / file).relative_to(PROJECT_ROOT)

                tb_files.append(
                    str(rel).replace("\\", "/")
                )

    # --------------------------------------------------------
    # Sort RTL Files
    # --------------------------------------------------------

    rtl_files.sort()

    # Keep Top Module Last

    rtl_files.sort(
        key=lambda x:
        (
            "RiscV_Core.v" in x,
            x
        )
    )

    tb_files.sort()

    # --------------------------------------------------------
    # Write filelist.f
    # --------------------------------------------------------

    with open(FILELIST, "w") as f:

        for file in rtl_files:
            f.write(file + "\n")

        for file in tb_files:
            f.write(file + "\n")

    # --------------------------------------------------------
    # Print File List
    # --------------------------------------------------------

    print("\n" + "="*60)
    print("FILE LIST")
    print("="*60)

    print("\nRTL Files\n")

    for file in rtl_files:
        print("  ✓", Path(file).name)

    print("\nTestbench\n")

    for file in tb_files:
        print("  ✓", Path(file).name)

    print("\n" + "="*60)

# ==========================================================
# Run Shell Command
# ==========================================================

def run(cmd):

    print("\n>>", cmd)

    result = subprocess.run(
        cmd,
        shell=True,
        cwd=PROJECT_ROOT
    )

    if result.returncode != 0:

        print("\n❌ Command Failed")

        sys.exit(result.returncode)

# ==========================================================
# Main
# ==========================================================

def main():

    print("\nCurrent Directory :")
    print(PROJECT_ROOT)

    clean()

    generate_filelist()

    print("\nCompiling...\n")

    run(
        f'iverilog -g2012 '
        f'-o "{SIM_OUT}" '
        f'-s {TOP_MODULE} '
        f'-f "{FILELIST}"'
    )

    print("\nRunning Simulation...\n")

    run(
        f'vvp "{SIM_OUT}"'
    )

    # ------------------------------------------------------
    # Open Waveform
    # ------------------------------------------------------

    if len(sys.argv) > 1:

        if sys.argv[1].lower() == "wave":

            if VCD_FILE.exists():

                print("\nOpening Waveform...\n")

                subprocess.run(
                    f'code "{VCD_FILE}"',
                    shell=True,
                    cwd=PROJECT_ROOT
                )

            else:

                print("\nWaveform not found!")

    print("\n" + "="*60)
    print("Simulation Completed Successfully")
    print("="*60)

# ==========================================================

if __name__ == "__main__":
    main()

