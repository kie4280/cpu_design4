#include <math.h>
#include <stdio.h>

#include <algorithm>
#include <iostream>

using namespace std;

struct cache_content {
  bool v;
  unsigned int tag;
  int time;
  // unsigned int  data[16];
};

bool compare(cache_content a, cache_content b) {
  if (a.time > b.time) return true;
  return false;
}

const int K = 1024;

double log2(double n) {
  // log(n) / log(2) is log2.
  return log(n) / log(double(2));
}

int access = 0;
int miss = 0;
void simulate(int cache_size, int n) {
  unsigned int tag, index, x, set_index;
  int block_size = 64;
  int offset_bit = (int)log2(block_size);
  int index_bit = (int)log2(cache_size / block_size);
  // int set_bit = (int)log2(n);
  int line = cache_size >> (offset_bit);

  cache_content *cache = new cache_content[line];

  // cout << "cache line: " << line << endl;

  for (int j = 0; j < line; j++) {
    cache[j].v = false;
    cache[j].time = 0;
  }

  FILE *fp = fopen("test/LU.txt", "r");  // read file

  while (fscanf(fp, "%x", &x) != EOF) {
    access++;
    // cout << hex << x << " ";
    index = (x >> offset_bit) & (line - 1);
    // set_index = index >> set_bit;
    set_index = index % (cache_size / (block_size * n));
    tag = x >> (index_bit + offset_bit);
    // cout << dec << set_index << " " << index << " " << tag << endl;

    bool fin = 0;
    for (int i = 0; i < n; i++)
      if (cache[set_index * n + i].v && cache[set_index * n + i].tag == tag) {
        cache[set_index * n + i].v = true;  // hit
        cache[set_index * n + i].time = 0;
        fin = 1;
        break;
      }

    if (fin == 0)
      for (int i = 0; i < n; i++)
        if (cache[set_index * n + i].v == false) {
          cache[set_index * n + i].v = true;  // miss
          cache[set_index * n + i].tag = tag;
          cache[set_index * n + i].time = 0;
          miss++;
          fin = 1;
          break;
        }

    if (fin == 0) {
      cache[set_index * n].v = true;  // miss
      cache[set_index * n].tag = tag;
      cache[set_index * n].time = 0;
      miss++;
      fin = 1;
    }

    sort(cache + set_index * n, cache + set_index * n + n, compare);
    
    for (int i = 0; i < n; i++) cache[set_index * n + i].time++;
  }
  fclose(fp);
  cout << (double)miss / access;
  delete[] cache;
}

int main() {
  // Let us simulate 4KB cache with n-way set-associative
  for (int a = 0; a <= 6; ++a) {
    for (int b = 0; b < 4; ++b) {
      simulate((4 << b * 2) * K, 1 << a);
      cout << " ";
      // cout << (4<<b*2) << "           " <<endl;
    }
    cout << endl;

  }
}