HANDLE varHeap;

bool InitHeap() { // run it in begin of program
  varHeap = HeapCreate(HEAP_GENERATE_EXCEPTIONS,
            1 * 1024,     // dwInitialSize = 1 kb
            0);           // If dwMaximumSize is zero, the heap is growable
                                       // (т.е. куча может расти)
  return (varHeap != NULL);
}

void * my_realloc(void * block, size_t size) {
  if (!size) {
    if (block)
      HeapFree(varHeap, 0, block);
    return NULL;
  }

  if (block)
    return HeapReAlloc(varHeap, HEAP_ZERO_MEMORY, block, size);
  else
    return HeapAlloc(varHeap, HEAP_ZERO_MEMORY, size);
}
