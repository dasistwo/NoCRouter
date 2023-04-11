`timescale 1ns / 1ps
package noc_params;

  // We will implement a 4x4 Mesh Network
	parameter MESH_SIZE_X = 4;
	parameter MESH_SIZE_Y = 4;

	localparam DEST_ADDR_SIZE_X = $clog2(MESH_SIZE_X);
	localparam DEST_ADDR_SIZE_Y = $clog2(MESH_SIZE_Y);

	parameter VC_NUM = 4;
	localparam VC_SIZE = $clog2(VC_NUM);

	localparam HEAD_PAYLOAD_SIZE = 16;

	typedef enum logic [2:0] {LOCAL, NORTH, SOUTH, WEST, EAST} port_t;
	parameter PORT_NUM = 5;
	localparam PORT_SIZE = $clog2(PORT_NUM);
  localparam PORT_WIDTH = 512;  // 512 bits = 64 Bytes
  parameter BUFFER_SIZE = 8;   // 8 flits

	typedef enum logic [1:0] {HEAD, BODY, TAIL, HEADTAIL} flit_label_t;

	typedef struct packed
	{
		logic [DEST_ADDR_SIZE_X-1 : 0] 	x_dest; //2
		logic [DEST_ADDR_SIZE_Y-1 : 0] 	y_dest; //2
		logic [HEAD_PAYLOAD_SIZE-1: 0] 	head_pl;  //16
	} head_data_t;

  // Flit size always should be 256 Bytes
	localparam FLIT_DATA_SIZE = PORT_WIDTH - HEAD_PAYLOAD_SIZE - DEST_ADDR_SIZE_X - DEST_ADDR_SIZE_Y - VC_SIZE - 2;

	typedef struct packed
	{
		flit_label_t			flit_label;
		logic [VC_SIZE-1 : 0] 	vc_id;
		struct packed
		{
			head_data_t 		head_data;
			logic [FLIT_DATA_SIZE-1 : 0] bt_pl;
		} data;
	} flit_t;

  typedef struct packed
  {
      flit_label_t flit_label;
      struct packed
      {
          head_data_t head_data;
          logic [FLIT_DATA_SIZE-1 : 0] bt_pl;
      } data;
  } flit_novc_t;

endpackage