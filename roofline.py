import argparse
import matplotlib.pyplot as plt
import numpy as np


def create_roofline_model(peak_performance, peak_bandwidth, my_operational_intensities=None, output_file_path=None):
    operational_intensities = np.logspace(-1, 4, num=100)

    performance = np.minimum(peak_performance, peak_bandwidth * operational_intensities)

    plt.loglog(operational_intensities, performance, label=f'Roofline Model with PP: {peak_performance}, PB: {peak_bandwidth}')

    if np.any(my_operational_intensities):
        for oi in my_operational_intensities:
            plt.axvline(x=oi, color='r', linestyle='--', label=f'OI={oi}')

    plt.xlabel('Operational Intensity (FLOPs/Byte)')
    plt.ylabel('Performance (GFLOPs/Second)')
    plt.grid(True)
    plt.legend()

    if output_file_path:
        plt.savefig(output_file_path + 'png')
    else:
        plt.show()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create a roofline model')
    parser.add_argument('-pp', '--peak-performance', type=float, dest="peak_performance", required=True, help='Peak Performance (FLOPs/Second)')
    parser.add_argument('-pb', '--peak-bandwidth', type=float, dest="peak_bandwidth", required=True, help='Peak Bandwidth (Bytes/Second)')
    parser.add_argument('-ois', '--operational-intensities', nargs='+', type=float, dest="operational_intensities", required=False, help='A list of integer values.')
    parser.add_argument('-o', '--output', type=str, dest="output_file_path", required=False, help='The filename to save the generated roofline model to')
    args = parser.parse_args()
    create_roofline_model(args.peak_performance, args.peak_bandwidth, args.operational_intensities, args.output_file_path)
