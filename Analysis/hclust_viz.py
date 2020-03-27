# @Author: Josef Klafka <academic>
# @Date:   2020-03-27T14:19:34-04:00
# @Email:  jlklafka@gmail.com
# @Project: Noisy-nets
# @Last modified by:   academic
# @Last modified time: 2020-03-27T16:17:16-04:00

Z = open("linkage.txt", 'r').read().splitlines()
expanded_barycenters = open("expanded_centers.txt", 'r').read().splitlines()

# ## plot entire dendrogram
# plt.figure(figsize = (50, 20), dpi = 100)
# fig, ax_main = plt.subplots()
# ## add dendro to axe as main plot
# dendro = dendrogram(Z, labels = languages.to_numpy(), ax = ax_main)
# plt.savefig("dendro.png")
