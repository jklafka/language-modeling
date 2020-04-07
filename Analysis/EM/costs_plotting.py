import argparse
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser()
parser.add_argument("--plotting", help="Whether to display the plot")
parser.add_argument("--marginal", help="Whether to plot marginal or total cost")
args = parser.parse_args()

plotting = False if args.plotting is None else True
marginal = False if args.marginal is None else True


costs = open("costs.txt", 'r').read().splitlines()
costs = ' '.join(costs).split("--")
costs = [item.strip(' ').split() for item in costs]
costs = [(int(barycenter_size), float(final_cost)) \
            for final_cost, barycenter_size in costs]

if plotting is True:
    sizes = [cost[0] for cost in costs]
    final_costs = [cost[1] for cost in costs]
    marginal_costs = [0] + [t - s for s, t in zip(final_costs, final_costs[1:])]

    fig = plt.figure()
    if marginal is True:
        plt.plot(sizes, marginal_costs)
        plt.ylabel("Marginal cost")
    else:
        plt.plot(sizes, final_costs)
        plt.ylabel("Final cost")
    plt.xlabel("Barycenter size")

    plt.show()
