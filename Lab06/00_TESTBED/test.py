# ========================================
# Designer: Will Lin (PCS Lab, NYCU, TW)
# ========================================
import random

SEED = 11599
# Set Pattern number 
PAT_NUM = 5000

# Creating tree nodes
class NodeTree(object):

    def __init__(self, left=None, right=None):
        self.left = left
        self.right = right

    def children(self):
        return (self.left, self.right)

    def nodes(self):
        return (self.left, self.right)

    def __str__(self):
        return '%s_%s' % (self.left, self.right)


# Main function implementing huffman coding
def huffman_code_tree(node, left=True, binString=''):
    if type(node) is str:
        return {node: binString}
    (l, r) = node.children()
    d = dict()
    d.update(huffman_code_tree(l, True, binString + '0'))
    d.update(huffman_code_tree(r, False, binString + '1'))
    return d

def get_huffman(nodes):

    while len(nodes) > 1:        
        # print(nodes)
        (key1, c1) = nodes[-1]
        (key2, c2) = nodes[-2]
        nodes = nodes[:-2]
        node = NodeTree(key2, key1)
        nodes.append((node, c1 + c2))

        nodes = sorted(nodes, key=lambda x: x[1], reverse=True)

        huffmanCode = huffman_code_tree(nodes[0][0])
    return huffmanCode
        


def gen_test_data(input_file_path,output_file_path, debug_file_path):
    # initial File path
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')
    pDFile = open(debug_file_path, 'w')    
    pIFile.write(f"{PAT_NUM}\n")

    mode = 0
    for j in range(PAT_NUM):
        # You can generate test data here
        chars = ["A", "B", "C", "E", "I", "L", "O", "V"]
        freq = {}
        if j == 0 or j == 1:
            freq = {"A": 3, "B": 7, "C": 6, "E": 5, "I": 3, "L": 3, "O": 5, "V": 7}
            mode = (mode + 1) % 2
        elif j<20:
            tmp = int(random.randrange(0,8))
            for i in chars:
                freq[i] = tmp
        elif j<50:
            tmp_list = [int(random.randrange(0,8)), int(random.randrange(0,8))]
            for i in chars:
                freq[i] = tmp_list[int(random.randrange(0,8))%2]
        else:
            for i in chars:
                freq[i] = int(random.randrange(0,8))
            mode = int(random.randrange(0,2))
        freq_list = list(freq.items())
        freq_list = sorted(freq_list, key=lambda x: x[1], reverse=True)
        huffman = get_huffman(freq_list)
        out_chars = [["I", "L", "O", "V", "E"], ["I", "C", "L", "A", "B"]]
        
        # print(' Char | Huffman code ')
        # print('----------------------')
        # for (char, frequency) in freq_list:
        #     print(' %-4r |%12s' % (char, huffman[char]))
        
        out_str = ""
        for s in out_chars[mode]:
            out_str += huffman[s]
        # input.txt
        pIFile.write(f"\n{mode}\n")
        for k in chars:
            pIFile.write(f"{freq[k]} ")
        pIFile.write(f"\n")

        # output.txt
        pOFile.write(f"{len(out_str)}\t{out_str}\n")

        # Debug file
        pDFile.write(f"[Pattern No. {j}]\n")
        pDFile.write(f"Mode: {mode}\n")
        pDFile.write(f"[INPUT]\n")
        for i, k in enumerate(chars):
            pDFile.write(f"{k}({i})\t")
        pDFile.write("\n")
        for k in chars: 
            pDFile.write(f"{freq[k]:<8}")

        pDFile.write(f"\n[Huffman encoding]\n")
        for k in chars:
            pDFile.write(f"{k:<8}")
        pDFile.write("\n")
        for k in chars: 
            pDFile.write(f"{huffman[k]:<8}")
        pDFile.write(f"\n[Golden]\n")
        for k in out_chars[mode]:
            pDFile.write(f"{k:<8}")
        pDFile.write("\n")
        for k in out_chars[mode]:
            pDFile.write(f"{huffman[k]:<8}")
        pDFile.write("\n\n")

# ++++++++++++++++++++ main +++++++++++++++++++++
def main():
    random.seed(SEED)
    gen_test_data("input.txt","output.txt", "debug.txt")

if __name__ == '__main__':
    main()