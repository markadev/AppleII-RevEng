# U52 Truth Tables

### Output ~ADDRHI_CIN (O1)

Truth table:

| LA15 (I1) | LA14 (I2) | LA13 (I3) | LA12 (I4) | | ~ADDRHI\_CIN (O1) |
| --------- | --------- | --------- | --------- |-| ----------------- |
|         0 |         0 |         0 |         0 | |                 1 |
|         0 |         0 |         0 |         1 | |                 1 |
|         0 |         0 |         1 |         0 | |                 1 |
|         0 |         0 |         1 |         1 | |                 1 |
|         0 |         1 |         0 |         0 | |                 1 |
|         0 |         1 |         0 |         1 | |                 1 |
|         0 |         1 |         1 |         0 | |                 1 |
|         0 |         1 |         1 |         1 | |                 1 |
|         1 |         0 |         0 |         0 | |                 1 |
|         1 |         0 |         0 |         1 | |                 1 |
|         1 |         0 |         1 |         0 | |                 1 |
|         1 |         0 |         1 |         1 | |                 0 |
|         1 |         1 |         0 |         0 | |                 0 |
|         1 |         1 |         0 |         1 | |                 0 |
|         1 |         1 |         1 |         0 | |                 0 |
|         1 |         1 |         1 |         1 | |                 1 |

### Output O2

Truth table:

| | O2 |
|-| -- |
| |  1 |

### Output ~ADDRHI_ADJ (O3)

Truth table:

| LA15 (I1) | LA14 (I2) | LA13 (I3) | LA12 (I4) | | ~ADDRHI\_ADJ (O3) |
| --------- | --------- | --------- | --------- |-| ----------------- |
|         0 |         0 |         0 |         0 | |                 1 |
|         0 |         0 |         0 |         1 | |                 1 |
|         0 |         0 |         1 |         0 | |                 1 |
|         0 |         0 |         1 |         1 | |                 1 |
|         0 |         1 |         0 |         0 | |                 1 |
|         0 |         1 |         0 |         1 | |                 1 |
|         0 |         1 |         1 |         0 | |                 1 |
|         0 |         1 |         1 |         1 | |                 1 |
|         1 |         0 |         0 |         0 | |                 1 |
|         1 |         0 |         0 |         1 | |                 1 |
|         1 |         0 |         1 |         0 | |                 1 |
|         1 |         0 |         1 |         1 | |                 1 |
|         1 |         1 |         0 |         0 | |                 1 |
|         1 |         1 |         0 |         1 | |                 1 |
|         1 |         1 |         1 |         0 | |                 0 |
|         1 |         1 |         1 |         1 | |                 1 |

### Output ~DMA_DATA_IN (O4)

Truth table:

| ~88RD (I6) | ~DRAM\_SEL (I9) | | ~DMA\_DATA\_IN (O4) |
| ---------- | --------------- |-| ------------------- |
|          0 |               0 | |                   1 |
|          0 |               1 | |                   0 |
|          1 |               0 | |                   1 |
|          1 |               1 | |                   1 |

### Output ~DMA_DATA_OUT (O5)

Truth table:

| ~DMA\_CYCLE (I5) | ~88WR (I7) | | ~DMA\_DATA\_OUT (O5) |
| ---------------- | ---------- |-| -------------------- |
|                0 |          0 | |                    0 |
|                0 |          1 | |                    1 |
|                1 |          0 | |                    1 |
|                1 |          1 | |                    1 |

### Output O6

Truth table:

| LA15 (I1) | LA14 (I2) | LA13 (I3) | LA12 (I4) | ~88INTA (I8) | | O6 |
| --------- | --------- | --------- | --------- | ------------ |-| -- |
|         0 |         0 |         0 |         0 |            0 | |  0 |
|         0 |         0 |         0 |         0 |            1 | |  1 |
|         0 |         0 |         0 |         1 |            0 | |  0 |
|         0 |         0 |         0 |         1 |            1 | |  1 |
|         0 |         0 |         1 |         0 |            0 | |  0 |
|         0 |         0 |         1 |         0 |            1 | |  1 |
|         0 |         0 |         1 |         1 |            0 | |  0 |
|         0 |         0 |         1 |         1 |            1 | |  1 |
|         0 |         1 |         0 |         0 |            0 | |  0 |
|         0 |         1 |         0 |         0 |            1 | |  1 |
|         0 |         1 |         0 |         1 |            0 | |  0 |
|         0 |         1 |         0 |         1 |            1 | |  1 |
|         0 |         1 |         1 |         0 |            0 | |  0 |
|         0 |         1 |         1 |         0 |            1 | |  1 |
|         0 |         1 |         1 |         1 |            0 | |  0 |
|         0 |         1 |         1 |         1 |            1 | |  1 |
|         1 |         0 |         0 |         0 |            0 | |  0 |
|         1 |         0 |         0 |         0 |            1 | |  1 |
|         1 |         0 |         0 |         1 |            0 | |  0 |
|         1 |         0 |         0 |         1 |            1 | |  1 |
|         1 |         0 |         1 |         0 |            0 | |  0 |
|         1 |         0 |         1 |         0 |            1 | |  1 |
|         1 |         0 |         1 |         1 |            0 | |  0 |
|         1 |         0 |         1 |         1 |            1 | |  0 |
|         1 |         1 |         0 |         0 |            0 | |  0 |
|         1 |         1 |         0 |         0 |            1 | |  0 |
|         1 |         1 |         0 |         1 |            0 | |  0 |
|         1 |         1 |         0 |         1 |            1 | |  0 |
|         1 |         1 |         1 |         0 |            0 | |  0 |
|         1 |         1 |         1 |         0 |            1 | |  1 |
|         1 |         1 |         1 |         1 |            0 | |  0 |
|         1 |         1 |         1 |         1 |            1 | |  1 |