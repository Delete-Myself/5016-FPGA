`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module VGA(clock,disp_RGB,hsync,vsync,left,right,middle,rst);
	input clock;    //ϵͳ����ʱ��100MHz
	input rst;     //��λ  
	input left,right,middle;//������3�����ư���
	output[5:0]disp_RGB;//VGA�������
	output hsync;//VGA��ͬ���ź�
	output vsync;//VGA��ͬ���ź�
	reg [9:0]  hcount;  //VGA��ɨ�������
	reg [9:0]  vcount; //VGA��ɨ�������
	reg [11:0]  data;  
	reg [11:0]  h_dat;
	reg [11:0]  v_dat;
	reg [11:0] x_dat;
	reg [11:0] data1;
	reg flag=0;
	wire hcount_ov;
	wire vcount_ov;
	wire dat_act;
	wire hsync;
	wire vsync;
	reg background=12'b010010000101;   
	reg gezi=12'b01010100001;
	reg jieshuse=12'hf00;
	reg vga_clk=0;
	reg cnt_clk=0;//��Ƶ����
   
	always@(posedge clock)
		begin
			if(cnt_clk==1)
			begin
				vga_clk<=~vga_clk;
				cnt_clk<=0;
			end
			else
			cnt_clk<=cnt_clk+1;
		end
//***************VGA��������*****************8//
//��ɨ��
// VGA�С���ɨ��ʱ�������
	parameter hsync_end =10'd95,
	hdat_begin=10'd143,
	hdat_end=10'd783,
	hpixel_end=10'd799,
	vsync_end=10'd1,
	vdat_begin =10'd34,
	vdat_end=10'd514,
	vline_end=10'd524;

//***************VGA��������*****************8//
//��ɨ��

	always@(posedge vga_clk)
		begin
			if(hcount_ov)
				hcount<=10'd0;
			else
				hcount <= hcount + 10'd1;
		end
	assign hcount_ov =(hcount==hpixel_end);

//��ɨ��
	always@(posedge vga_clk)
		begin 
			if(hcount_ov)
			begin 
				if(vcount_ov)
					vcount<=10'd0;
				else 
					vcount<=vcount+10'd1;
			end
		end
	assign vcount_ov=(vcount==vline_end);
    
    //���ݡ�ͬ���ź�
    //adt_actͼ��������Ч��־�ź�
    assign dat_act=((hcount>=hdat_begin)&&(hcount<hdat_end))&&((vcount>=vdat_begin)&&(vcount<vdat_end));
    assign hsync=(hcount>hsync_end);
    assign vsync=(vcount>vsync_end);
   
   //����ǿ�������ѡһ��·��
    assign disp_RGB=(dat_act)?data:6'h00;
   //diso_RGBΪ�����VGA�ӿ����ݣ�dataΪ����ģ�鴫�ݵ���ȷͼ������
    
//��ʱ1��
	reg [28:0]jishu_1s=0;
	reg clk_1s=0;
	localparam tick=50000000;
	always @ (posedge clock)
		begin
         if(jishu_1s==tick)
         begin
				jishu_1s<=0;
				clk_1s=~clk_1s;
         end
			else
         begin
				jishu_1s<=jishu_1s+1;
         end 
		end

//��ʱ50ms
	reg clk_50ms=0;
   localparam DVSR=5000000;
   reg [28:0] js;
	always @ (posedge clock)
		begin
         if(js==DVSR)
         begin
				js<=0;
				clk_50ms=~clk_50ms;
         end
			else
         begin
				js<=js+1;
         end 
		end


//����������
	always@(posedge vga_clk)
		begin
			if(hcount<=220||hcount>=620)
				v_dat <= 12'h000;//hei
			else if(hcount==240 ||hcount ==360||hcount ==480||hcount==600)
				v_dat <= 12'h000;//hei
			else 
				v_dat <= 12'hfff;//bai
		end

//�����᳤��
	always@(posedge vga_clk)
		begin
			if(vcount<=70||vcount>=470)
				h_dat <= 12'h000;//hei
			else if(vcount==90 ||vcount ==210||vcount ==330||vcount ==450)
				h_dat <= 12'h000;
			else
				h_dat <= 12'hfff;                                                      //����
		end


	parameter	WIDTH = 60, //���γ�
					HEIGHT = 60,  //���ο�
               //��ʾ����ı߽�
					DISV_TOP = 10'd120,
					DISV_DOWN =DISV_TOP+HEIGHT,
					DISH_LEFT = 10'd270,
					DISH_RIGHT = DISH_LEFT + WIDTH;
					//��ʼ���ε�λ�ã�����ʾ�������½�               
					reg [9:0] topbound =DISV_TOP;
					reg [9:0] downbound  ;
					reg [9:0] leftbound = DISH_LEFT ;
					reg [9:0] rightbound  ;
					reg [1:0] weizhi=0;
          
	//3��λ����Ϣ                        
	always@(posedge clk_50ms)
	begin
		case(weizhi[1:0])
         3'b00:
			begin 
				leftbound<=10'd270;
				topbound<=10'd240; //��
         end 
			3'b01:  
			begin 
				leftbound<=10'd390;
				topbound<=10'd240;   //��                                           
			end
			3'b10:  
			begin
				leftbound<=10'd510;
				topbound<=10'd240;  //��
			end                         
		endcase
	end

	reg flag_on=0;
//����λ������Ļ�ϵ���λ����ͬ����ı���Ļ�ϵ���ɫ�����ɫ
   always @(posedge clk_50ms) 
		begin 
			if( left==1 && weizhi==0 )
			begin
				flag<=1;//   flag_on<=1;
            end
            else if( middle==1 && weizhi==1 )
			begin
            flag<=1; //   flag_on<=1;
            end
		  	else if( right==1 && weizhi==2 )
			begin
            flag<=1;
            flag_on<=1;
         end
         else  
			begin
            flag<=0; //    flag_on<=0;
         end
		end
                             
	reg [5:0] i=0;

//ÿ��2��ɫ�黻һ��λ��
//20λ��α�����
	wire [7:0] position[0:19];
	assign position[0]=0;
	assign position[1]=2; 
	assign position[2]=1;
	assign position[3]=2;
	assign position[4]=1;
	assign position[5]=0;
	assign position[6]=1; 
	assign position[7]=0;
	assign position[8]=2;
	assign position[9]=1;
	assign position[10]=1;
	assign position[11]=0;
	assign position[12]=1;
	assign position[13]=1; 
	assign position[14]=2;
	assign position[15]=0;
	assign position[16]=0;
	assign position[17]=2;
	assign position[18]=2; 
	assign position[19]=0; 



	reg [11:0]data2=12'h652;
	reg count_20=0;
	reg [5:0]num=0;              
	reg [5:0]num1=0;    
	reg [5:0]cnt_60ss=60;    
	reg flag_kaishi=0;
	reg flag_jieshu=0;
	reg [4:0]cnt_60s=0;
  
  //�������ʱ�估��ز�������ģ��
	always@(posedge clk_1s)
		begin
			i<=i+1;
			weizhi<=position[i];
			if(i>=19)
				i<=0;
			if(weizhi>=2)
				weizhi<=0;
			if(flag==1)
				num1<=num1+1;
			if(num1==60)
			begin
				num1<=0;
				x_dat<= data2;
			end
			if(rst==1)
				num1<=0;
			if( flag_kaishi )
				cnt_60ss<=cnt_60ss-1;
			if(cnt_60ss==0)
				cnt_60ss<=0;
		end
           
                //��ɫһ��Сɫ��
	always @(posedge clock) 
		begin  
			rightbound = leftbound + 10'd60 ;
			downbound = topbound + 10'd60;
			if( hcount >= leftbound &&  hcount <= rightbound &&  vcount<= downbound &&  vcount >= topbound && flag==0)
				x_dat<= 12'h0f0;
			else if( hcount >= leftbound &&  hcount <= rightbound &&  vcount<= downbound &&  vcount >= topbound && flag==1)
			begin
				x_dat<= 12'hf00;     
			end    
			else 
				x_dat<=12'hfff; //��ɫ
		end               
//����ˢ�£�����ʱ��������
	always@(posedge clock)
		begin
			if(rst==1)
				num<=0;
				cnt_60ss<=60;
		end
		
  //��ʾͼ��  
	always@(posedge clock)
		begin
			if(rst)
			begin
				data1<=h_dat&v_dat;
				cnt_60ss<=60;
				flag_kaishi=0;
				flag_jieshu=0;
			end
    
    //��һ�ν����λ���а������£��������Ϸ����
			if(!rst &&left==1||right==1||middle==1)
				flag_kaishi=1;
		
     //��Ϸ��ʼ����Ϸ������־λδ��һ������ʾ��Ϸ����
			if(!rst && flag_kaishi==1 && !flag_jieshu)
				data1<=x_dat&h_dat&v_dat;
    
     //����ʱ60s������������־λ��һ
			if(cnt_60ss==0)
			begin
				flag_jieshu=1;      
			end       
			data<=data1;    
		end
endmodule
