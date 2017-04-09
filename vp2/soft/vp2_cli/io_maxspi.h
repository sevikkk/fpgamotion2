#define MAXSPI_DATA REG(0xD200)
#define MAXSPI_STATUS REG(0xD201)
#define 	MAXSPI_STATUS_SS 0x01
#define 	MAXSPI_STATUS_RXRDY 0x02
#define 	MAXSPI_STATUS_TXFULL 0x04
#define 	MAXSPI_STATUS_TXEMPTY 0x08
#define 	MAXSPI_STATUS_DEVNUM 0x30
#define 	MAXSPI_STATUS_DEVNUM_SHIFT 4
#define MAXSPI_DELAY REG(0xD202)
