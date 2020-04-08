import argparse, csv
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
parser.add_argument("gram", help="Unigram or trigram")
parser.add_argument("--plotting", help="Whether to display the plot")
parser.add_argument("--marginal", help="Whether to plot marginal or total cost")
parser.add_argument("--printing", help="Whether to print costs to file")
args = parser.parse_args()

# plot by default, else print
printing = False if args.printing is None else True
plotting = False if (args.plotting is None and printing is True) else True
marginal = False if args.marginal is None else True


costs = open("costs.txt", 'r').read().splitlines()
costs = ' '.join(costs).split("--")
costs = [item.strip(' ').split() for item in costs]
costs = [(int(barycenter_size), float(final_cost)) \
            for final_cost, barycenter_size in costs]

sizes = [cost[0] for cost in costs]
final_costs = [cost[1] for cost in costs]
marginal_costs = [0] + [cost_i - cost_j for cost_j, cost_i
                        in zip(final_costs, final_costs[1:])]

if plotting is True:
    fig = plt.figure()
    if marginal is True:
        plt.plot(sizes, marginal_costs)
        plt.ylabel("Marginal cost")
    else:
        plt.plot(sizes, final_costs)
        plt.ylabel("Final cost")
    plt.xlabel("Barycenter size")

    plt.show()


if printing is True:
    data = zip(sizes, final_costs, marginal_costs)
    with open("em_costs.csv", 'a') as costs_file:
        writer = csv.writer(costs_file)
        for row in data:
            writer.writerow(list(row) + [args.corpus, args.language, args.gram])
