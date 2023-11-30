`timescale 1 ns / 1 ns // timescale for following modules

///////////////////////////////////////////////////////////////////////////////////
// // Engineer: Oguz Kaan Agac & Bora Ecer
// Create Date: 13/12/2016
// // Modified by: Abdul Rafay, Ali Imran
// Modified Date: 23/11/2023
// Design Name: Animation Logic
// Module Name: anim_gen
// Original Project Name: BASPONG
// Modified Project Name: FoosballStars
// Target Devices: BASYS3
// Description: 
// Controller for the FoosballStars
// Dependencies: 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module anim_gen (
   clk, // basic clock
   reset, // to reset game
   x_control, // input for x coordinate
   stop_ball, // input to indicate if ball is stopped at center or moving
   bottom_button_l,
   bottom_button_r,
   top_button_l,
   top_button_r,
   right2_btn_d,
   right2_btn_u,
   y_control, // input for y coordinate
   video_on, // input to tell we're in safe zone to draw
   rgb, // output for vga display
   score1, // output for score on seven segment display
   score2); // output for score on seven segment display
 
input clk; 
input reset; 
input[9:0] x_control; 
input stop_ball; 
input bottom_button_l; 
input bottom_button_r; 
input top_button_l; 
input top_button_r;
input right2_btn_d;
input right2_btn_u; 
input[9:0] y_control; 
input video_on; 
output[2:0] rgb; 
output score1; 
output score2; 

reg[2:0] rgb; 
reg score1; 
reg score2; 
reg scoreChecker1; 
reg scoreChecker2; 
reg scorer; 
reg scorerNext; 

// topbar
integer topbar_t; // the distance between bar and top of the screen 
integer topbar_t_next; // the distance between bar and top of the screen
parameter topbar_l = 20; // the distance between bar and left side of screen
parameter topbar_thickness = 10; // thickness of the bar
parameter topbar_w = 120; // width of the top bar
parameter topbar_v = 10; //velocity of the bar.
wire display_topbar; //to send top bar to vga
wire[2:0] rgb_topbar; //color 

// rightbar
integer rightbar2_t; // the distance between bar and top of the screen 
integer rightbar2_t_next; // the distance between bar and top of the screen
parameter rightbar2_l = 520; // the distance between bar and left side of screen
parameter rightbar2_thickness = 10; // thickness of the bar
parameter rightbar2_w = 100; // width of the right2 bar
parameter rightbar2_v = 8; //velocity of the bar.
wire display_rightbar2; //to send right2 bar to vga
wire[2:0] rgb_rightbar2; //color 

// bottombar
integer bottombar_t;  // the distance between bar and top side of screen
integer bottombar_t_next; // the distance between bar and top side of screen
parameter bottombar_l = 620; // the distance between bar and left side of screen
parameter bottombar_thickness = 10; //thickness of the bar
parameter bottombar_w = 120; // width of the bottom bar
parameter bottombar_v = 10; //velocity of the bar
wire display_bottombar; //to send bottom bar to vga
wire[2:0] rgb_bottombar; //color

// ball
integer ball_c_l; // the distance between the ball and left side of the screen
integer ball_c_l_next; // the distance between the ball and left side of the screen 
integer ball_c_t; // the distance between the ball and top side of the screen
integer ball_c_t_next; // the distance between the ball and top side of the screen
parameter ball_default_c_t = 300; // default value of the distance between the ball and left side of the screen
parameter ball_default_c_l = 300; // default value of the distance between the ball and left side of the screen
parameter ball_r = 8; //radius of the ball.
parameter horizontal_velocity = 3; // Horizontal velocity of the ball  
parameter vertical_velocity = 3; //Vertical velocity of the ball
wire display_ball; //to send ball to vga 
wire[2:0] rgb_ball;//color 

// refresh
integer refresh_reg; 
integer refresh_next; 
parameter refresh_constant = 830000;  
wire refresh_rate; 

// ball animation
integer horizontal_velocity_reg; 
integer horizontal_velocity_next; 
integer vertical_velocity_reg; 

// x,y pixel cursor
integer vertical_velocity_next; 
wire[9:0] x; 
wire[8:0] y; 

// wall registers
wire display_goal;

// mux to display
wire[5:0] output_mux; 

// buffer
reg[2:0] rgb_reg; 

// x,y pixel cursor
wire[2:0] rgb_next; 

initial
    begin
    vertical_velocity_next = 0;
    vertical_velocity_reg = 0;
    horizontal_velocity_reg = 0;
    ball_c_t_next = 300;
    ball_c_t = 300;
    ball_c_l_next = 300;  
    ball_c_l = 300; 
    bottombar_t_next = 260;
    bottombar_t = 260;
    topbar_t_next = 260;
    topbar_t = 260;
    rightbar2_t_next = 220;
    rightbar2_t = 220;
   end
assign x = x_control; 
assign y = y_control; 

// refreshing

always @(posedge clk)
   begin //: process_1
   refresh_reg <= refresh_next;   
   end

//assigning refresh logics.
assign refresh_next = refresh_reg === refresh_constant ? 0 : 
	refresh_reg + 1; 
assign refresh_rate = refresh_reg === 0 ? 1'b 1 : 
	1'b 0; 

// register part
always @(posedge clk or posedge reset)
   begin 
   if (reset === 1'b 1) // to reset the game.
      begin
      ball_c_l <= ball_default_c_l;   
      ball_c_t <= ball_default_c_t;   
      bottombar_t <= 260;   
      topbar_t <= 260;   
      rightbar2_t <= 220;   
      horizontal_velocity_reg <= 0;   
      vertical_velocity_reg <= 0;   
      end
   else 
      begin
      horizontal_velocity_reg <= horizontal_velocity_next; //assigns horizontal velocity
      vertical_velocity_reg <= vertical_velocity_next; // assigns vertical velocity
      if (stop_ball === 1'b 1) // throw the ball
         begin
         if (scorer === 1'b 0) // if scorer is not the 1st player throw the ball to 1st player (2nd player scored) .
            begin
            horizontal_velocity_reg <= 4;   
            vertical_velocity_reg <= 3;   
            end
         else // first player scored. Throw the ball to the 2nd player.
            begin
            horizontal_velocity_reg <= -4;   
            vertical_velocity_reg <= -3;   
            end
         end
      ball_c_l <= ball_c_l_next; //assigns the next value of the ball's location from the left side of the screen to it's location.
      ball_c_t <= ball_c_t_next; //assigns the next value of the ball's location from the top side of the screen to it's location.  
      bottombar_t <= bottombar_t_next;   //assigns the next value of the bottom bars's location from the left side of the screen to it's location.
      topbar_t <= topbar_t_next;   //assigns the next value of the top bars's location from the left side of the screen to it's location.
      rightbar2_t <= rightbar2_t_next;   //assigns the next value of the right bars's location from the left side of the screen to it's location.
      scorer <= scorerNext;
      end
   end

// bottombar animation
always @(bottombar_t or refresh_rate or bottom_button_r or bottom_button_l)
   begin 
   bottombar_t_next <= bottombar_t;//assign bottombar_l to it's next value   
   if (refresh_rate === 1'b 1) //refresh_rate's posedge 
      begin
      if (bottom_button_l === 1'b 1 & bottombar_t > bottombar_v) //left button is pressed and bottom bar can move to the left.
         begin                                                   // in other words, bar is not on the left edge of the screen.
         bottombar_t_next <= bottombar_t - bottombar_v; // move bottombar to the left   
         end
      else if (bottom_button_r === 1'b 1 & bottombar_t < 479 - bottombar_v - bottombar_w ) //right button is pressed and bottom bar can move to the right 
         begin                                                                             //in other words, bar is not on the right edge of the screen
         bottombar_t_next <= bottombar_t + bottombar_v;   //move bottombar to the right.
         end
      else
         begin
         bottombar_t_next <= bottombar_t;   
         end
      end
   end

// rightbar2 animation
always @(rightbar2_t or refresh_rate or right2_btn_d or right2_btn_u)
   begin 
   rightbar2_t_next <= rightbar2_t;//assign rightbar2_l to it's next value   
   if (refresh_rate === 1'b 1) //refresh_rate's posedge 
      begin
      if (right2_btn_u === 1'b 1 & rightbar2_t > rightbar2_v) //left button is pressed and bottom bar can move to the left.
         begin                                                   // in other words, bar is not on the left edge of the screen.
         rightbar2_t_next <= rightbar2_t - rightbar2_v; // move rightbar2 to the left   
         end
      else if (right2_btn_d === 1'b 1 & rightbar2_t < 479 - rightbar2_v - rightbar2_w ) //right button is pressed and bottom bar can move to the right 
         begin                                                                             //in other words, bar is not on the right edge of the screen
         rightbar2_t_next <= rightbar2_t + rightbar2_v;   //move rightbar2 to the right.
         end
      else
         begin
         rightbar2_t_next <= rightbar2_t;   
         end
      end
   end

// topbar animation
always @(topbar_l or refresh_rate or top_button_r or top_button_l)
   begin 
   topbar_t_next <= topbar_t;   //assign topbar_l to it's next value
   if (refresh_rate === 1'b 1)  //refresh_rate's posedge
      begin
      if (top_button_l === 1'b 1 & topbar_t > topbar_v)//left button is pressed and top bar can move to the left.
          begin                                        // in other words, bar is not on the left edge of the screen.
         topbar_t_next <= topbar_t - topbar_v;   //move top bar to the left
         end
      else if (top_button_r === 1'b 1 & topbar_t < 479 - topbar_v - topbar_w ) //right button is pressed and bottom bar can move to the right 
        begin                                                                  //in other words, bar is not on the right edge of the screen
         topbar_t_next <= topbar_t + topbar_v;   // move top bar to the right
         end
      else
         begin
         topbar_t_next <= topbar_t;   
         end
      end
   end

// ball animation
always @(refresh_rate or ball_c_l or ball_c_t or horizontal_velocity_reg or vertical_velocity_reg)
   begin 
   ball_c_l_next <= ball_c_l;   
   ball_c_t_next <= ball_c_t;   
   scorerNext <= scorer;   
   horizontal_velocity_next <= horizontal_velocity_reg;   
   vertical_velocity_next <= vertical_velocity_reg;   
   scoreChecker1 <= 1'b 0; //1st player did not scored, default value
   scoreChecker2 <= 1'b 0; //2st player did not scored, default value  
   if (refresh_rate === 1'b 1) // posedge of refresh_rate
      begin
      if (ball_c_t >= bottombar_t & ball_c_t <= bottombar_t +120 & ball_c_l >= bottombar_l - 3 & ball_c_l <= bottombar_l + 5) 
      // if ball hits the bottom bar
         begin
         horizontal_velocity_next <= -horizontal_velocity; // set the direction of vertical velocity positive
         end
      else if (ball_c_t >= topbar_t & ball_c_t <= topbar_t + 120 & ball_c_l >= topbar_l + 7 & ball_c_l <= topbar_l + 12 ) 
      // if ball hits the top bar 
         begin
         horizontal_velocity_next <= horizontal_velocity; //set the direction of vertical velocity positive  
         end
      if (ball_c_t < 20) // if the ball hits the top side of the screen
         begin
         vertical_velocity_next <= vertical_velocity; //set the direction of vert velocity positive
         // positive = right, negative = left
         end
      else if (ball_c_t > 460 ) // if the ball hits the bottom side of the screen
         begin
         vertical_velocity_next <= -vertical_velocity; //set the direction of vert velocity negative.
         // therefore, positive = bottom, negative = top
         end
      else if ((ball_c_l >= 620) & (ball_c_t < 190 | ball_c_t > 290)) // ball hits right borders
        begin
        horizontal_velocity_next <= -horizontal_velocity;
        end
      else if ((ball_c_l === 3) & (ball_c_t < 140 | ball_c_t > 340)) // ball hits left borders
        begin
        horizontal_velocity_next <= horizontal_velocity;
        end 
      
      ball_c_l_next <= ball_c_l + horizontal_velocity_reg; //move the ball's horizontal location   
      ball_c_t_next <= ball_c_t + vertical_velocity_reg; // move the ball's vertical location.
      if (ball_c_l === 637 & ball_c_t >= 140 & ball_c_t <= 340) // if player 1 scores, in other words, ball passes through the vertical location of bottom bar.
         begin
         ball_c_l_next <= ball_default_c_l;  //reset the ball's location to its default.  
         ball_c_t_next <= ball_default_c_t;  //reset the ball's location to its default.
         horizontal_velocity_next <= 0; //stop the ball.  
         vertical_velocity_next <= 0; //stop the ball
         scorerNext <= 1'b 0;   
         scoreChecker1 <= 1'b 1; //1st player scored.  
         end
      else
         begin
         scoreChecker1 <= 1'b 0;   
         end
      if (ball_c_l === 3  & ball_c_t >= 140 & ball_c_t <= 340)// if player 2 scores, in other words, ball passes through the vertical location of top bar.
         begin
         ball_c_l_next <= ball_default_c_l; //reset the ball's location to its default.   
         ball_c_t_next <= ball_default_c_t; //reset the ball's location to its default.  
         horizontal_velocity_next <= 0; //stop the ball  
         vertical_velocity_next <= 0; //stop the ball  
         scorerNext <= 1'b 1;   
         scoreChecker2 <= 1'b 1;  // player 2 scored  
         end
      else
         begin
         scoreChecker2 <= 1'b 0;   
         end
      end
   end

// display bottombar object on the screen
assign display_bottombar = y > bottombar_t & y < bottombar_t + bottombar_w & x > bottombar_l & 
    x < bottombar_l + bottombar_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_bottombar = 3'b 100; //color of bottom bar: blue

// display rightbar2 object on the screen
assign display_rightbar2 = y > rightbar2_t & y < rightbar2_t + rightbar2_w & x > rightbar2_l & 
    x < rightbar2_l + rightbar2_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_rightbar2 = 3'b 110; //color of bottom bar: yellow

// display topbar object on the screen
assign display_topbar = y > topbar_t & y < topbar_t + topbar_w & x > topbar_l &
    x < topbar_l + topbar_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_topbar = 3'b 001; // color of top bar: red


// display goal on the screen
assign display_goal = (y >= 140 & x <= 340 & (x >= 637 | x <= 3)) ? 1'b 1 : 1'b 0;

// display ball object on the screen
assign display_ball = (x - ball_c_l) * (x - ball_c_l) + (y - ball_c_t) * (y - ball_c_t) <= ball_r * ball_r ? 
    1'b 1 : 
	1'b 0; 
assign rgb_ball = 3'b 111; //color of ball: white

always @(posedge clk)
   begin 
   rgb_reg <= rgb_next;   
   end

// mux
assign output_mux = {video_on, display_goal, display_topbar, display_bottombar, display_rightbar2, display_ball}; 

//assign rgb_next wrt output_mux.
assign rgb_next = output_mux === 6'b 100000 ? 3'b 010 : 
	output_mux === 6'b 110000 ? 3'b 111 : 
	output_mux === 6'b 101000 ? rgb_bottombar : 
	output_mux === 6'b 100100 ? rgb_topbar : 
	output_mux === 6'b 100010 ? rgb_rightbar2 :  
	output_mux === 6'b 100001 ? rgb_ball :
	3'b 000;        
	
//assign rgb_next = (video_on) ? 3'b 010 : 3'b 000;
//assign rgb_next = (display_goal & rgb_next == 3'b 010) ? 3'b 111 : rgb_next;
//assign rgb_next = (display_topbar & rgb_next == 3'b 010) ? rgb_topbar : rgb_next;
//assign rgb_next = (display_bottombar & rgb_next == 3'b 010) ? rgb_bottombar : rgb_next;
//assign rgb_next = (display_ball & rgb_next == 3'b 010) ? rgb_ball : rgb_next;

// output part
assign rgb = rgb_reg; 
assign score1 = scoreChecker1; 
assign score2 = scoreChecker2; 

endmodule // end of module anim_gen