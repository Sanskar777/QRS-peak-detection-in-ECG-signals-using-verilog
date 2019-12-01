`timescale 10ps / 1fs

module CLT(Yin, clk, out, i);

  input [31:0]  Yin;              // this is the input ECG value we receive expressed in 32 bits (2's complement form)
  input clk;                      // input clock pulse
  input [10:0]i;                  // the sample number of the received ECG signal
  output reg [31:0] out;          // stores the max CLT value of the dataset on a window size of 30 in binary format
  reg [31:0] mem [31:0];          // the 32 bit input values are stored in an array of size 32 as we need memory for performing CLT
  integer c=2;                    // an integer constant used for CLT calculations
  integer w=30;                   // an integer constant used for CLT calculations
  integer outx;                   // stores the max CLT value as an integer rather than binary format
  integer x1=0, x2=0, x3=0, x4=0; // integers used in intermediate calculations
  integer ns=0;                   // next sum used in intermediate calculations
  integer ps=0;                   // previous sum used in intermediate calculations
  integer stored_val =0;          // integer used in intermediate calculations
  integer alpha1, alpha2, alpha3, alpha4;       // integer used in intermediate calculations
  integer stored_2 =0;                          // integer used in intermediate calculations
  integer peak_clt_val;                         // stores the magnitude of the max CLT applied on the input batch
  integer clt_peak_index =0;                    // stores the sample number of the R-peak
  integer flag=0;                               // flag variable used for intermediate calculations
  integer max_qrs =0, threshold =0, curr_index=0, curr_val=0;
  integer curr_index_store=0, s_peak_index =0 ,s_peak_val=0, q_peak_val=0, q_peak_index=0;        //these variables have been described as and when used

 always @(posedge clk)               // At every positive edge of the clock we perform the calculations
 begin
  mem[i%32]=Yin;                     // The input values are appropriately stored in the mem array
  //$display("%9b %9b %32b", i, i%32, mem[i%32]);
  alpha1 = mem[i%32];
  alpha2 = mem[(i-1)%32];
  alpha3 = mem[(i-w)%32];             //converting reg values to integers to easily use them in if else statements
  alpha4 = mem[(i-w-1)%32];
  if(i>0 && i<=31) begin
    x1 = alpha1 > alpha2? alpha1 - alpha2 :alpha2 - alpha1;
    x2 = c + x1 + x1 + x1 + x1;               // accumulating sum until we get 32 values
    ns = ps + x2;
  end
  else if(i>31) begin
    x1 = alpha1 > alpha2? alpha1 - alpha2 :alpha2 - alpha1;
    x2 = c + x1 + x1 + x1 + x1;
    x3 =  alpha3>alpha4 ? alpha3 - alpha4 : alpha4 - alpha3;
    x4 = c + x3 + x3 + x3 + x3;               // once we have atleast 32 values we aaply the CLT algorithm
    ns = ps + x2 - x4;                        // to get the curve length for the batch of 32 inputs
  end
  outx = ns;
  //$display( " %d %d %d %d %d %d",x1, x2, x3, x4,ps,ns);
  //$display( " %d ", outx);
  out = outx;
  //$display( " %32b ", out);
  ps = ns;                                // now previous sum is made equal to the current CLT value calculated
  if (i <200)
  begin
    if (outx >stored_val)                 // using this we calculate the maximum CLT value for the incoming batch of 200 inputs
    stored_val = outx;
  end
  if (i>200)
  begin
    if (stored_val%2==0)                  // now for samples > 200 we use this threshold to detect QRS peaks
        threshold = stored_val;
    else
        threshold = (stored_val-1);       // threshold contains the lower bound for a QRS peak
  end
  if (i>200)
  begin
    if (outx>threshold)                   // here we are implementing the FSM using if-else statements
    begin
        if(outx> stored_2)
            stored_2 = outx;                 // ClT maxima is achieved until this if statement is true
        else begin
            peak_clt_val = stored_2;         // peak_clt_val stores the CLT maxima for the incoming batch

            curr_index = i;                  // stores the index of the sample whose value + last 31 values gives CLT maxima
            curr_val = mem[curr_index%32];   // stores the value of the sample whose value + last 31 values gives CLT maxima
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;     // from this sample we go back 15 samples to get the maximum sample value
            max_qrs = curr_val;              // this maximum gives magnitude of R peak and sample number gives location of R peak
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin                           // since FOR loop is not synthesizable, we use if-else 15 times for this purpose
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;                  // max_qrs stores the magnitude of R-peak
            end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val>max_qrs)
            begin
            clt_peak_index = curr_index;
            max_qrs = curr_val;
            end
            $display(" R peak value is %d ", max_qrs, " and sample number is %d ", clt_peak_index);

            // here we get R-peak and its sample number
            // r peak is detected .. now we shall detect q and s peaks

             curr_index_store = clt_peak_index; // this stores the R-peak index
             curr_index = curr_index_store;     // from the R-peak index we go 15 values to the left to find the minimum ECG value

             q_peak_val = max_qrs;              // This minimum is the Q-peak value and its index the Q-peak index

             curr_index = curr_index-1;
             curr_val = mem[curr_index%32];
             if (curr_val<q_peak_val)
             begin
             q_peak_index = curr_index;
             q_peak_val = curr_val;
             end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;
            q_peak_val = curr_val;
            end


            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;
            q_peak_val = curr_val;
            end


            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;
            q_peak_val = curr_val;
            end

            curr_index = curr_index-1;
             curr_val = mem[curr_index%32];
             if (curr_val<q_peak_val)
             begin
             q_peak_index = curr_index;
             q_peak_val = curr_val;
             end

             curr_index = curr_index-1;
          curr_val = mem[curr_index%32];
          if (curr_val<q_peak_val)
          begin
          q_peak_index = curr_index;
          q_peak_val = curr_val;
          end

          curr_index = curr_index-1;
           curr_val = mem[curr_index%32];
           if (curr_val<q_peak_val)
           begin
           q_peak_index = curr_index;
           q_peak_val = curr_val;
           end

           curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;            // these if-else statements are a substitute for 'loops'
            q_peak_val = curr_val;
            end

            curr_index = curr_index-1;
             curr_val = mem[curr_index%32];
             if (curr_val<q_peak_val)
             begin
             q_peak_index = curr_index;
             q_peak_val = curr_val;
             end

            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;
            q_peak_val = curr_val;
            end


            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;
            q_peak_val = curr_val;
            end


            curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;
            q_peak_val = curr_val;
            end

            curr_index = curr_index-1;
             curr_val = mem[curr_index%32];
             if (curr_val<q_peak_val)
             begin
             q_peak_index = curr_index;
             q_peak_val = curr_val;
             end

             curr_index = curr_index-1;
          curr_val = mem[curr_index%32];
          if (curr_val<q_peak_val)
          begin
          q_peak_index = curr_index;
          q_peak_val = curr_val;
          end

          curr_index = curr_index-1;
           curr_val = mem[curr_index%32];
           if (curr_val<q_peak_val)
           begin
           q_peak_index = curr_index;
           q_peak_val = curr_val;
           end

           curr_index = curr_index-1;
            curr_val = mem[curr_index%32];
            if (curr_val<q_peak_val)
            begin
            q_peak_index = curr_index;
            q_peak_val = curr_val;
            end

          $display(" Q peak value is %d ", q_peak_val, " and sample number is %d ", q_peak_index);

         // Q-peak gets detected
         // now we need to detect the S peak

          s_peak_index = 0;
          s_peak_val = max_qrs;
          curr_index = curr_index_store;

          curr_index = curr_index+1;
          curr_val = mem[curr_index%32];
          if (curr_val<s_peak_val)              // to detect S-peak we find minima in 15 values starting from R-peak index
          begin
          s_peak_index = curr_index;
          s_peak_val = curr_val;
          end

            curr_index = curr_index+1;
            curr_val = mem[curr_index%32];
            if (curr_val<s_peak_val)
            begin
            s_peak_index = curr_index;
            s_peak_val = curr_val;
            end

            curr_index = curr_index+1;
            curr_val = mem[curr_index%32];
            if (curr_val<s_peak_val)
            begin
            s_peak_index = curr_index;
            s_peak_val = curr_val;
            end

            curr_index = curr_index+1;
            curr_val = mem[curr_index%32];
            if (curr_val<s_peak_val)
            begin
            s_peak_index = curr_index;
            s_peak_val = curr_val;
            end

            curr_index = curr_index+1;
              curr_val = mem[curr_index%32];
              if (curr_val<s_peak_val)
              begin
              s_peak_index = curr_index;
              s_peak_val = curr_val;
              end

              curr_index = curr_index+1;
            curr_val = mem[curr_index%32];
            if (curr_val<s_peak_val)
            begin
            s_peak_index = curr_index;
            s_peak_val = curr_val;
            end

            curr_index = curr_index+1;
              curr_val = mem[curr_index%32];
              if (curr_val<s_peak_val)
              begin
              s_peak_index = curr_index;
              s_peak_val = curr_val;
              end

            curr_index = curr_index+1;
            curr_val = mem[curr_index%32];
            if (curr_val<s_peak_val)
            begin
            s_peak_index = curr_index;
            s_peak_val = curr_val;
            end

            curr_index = curr_index+1;
              curr_val = mem[curr_index%32];
              if (curr_val<s_peak_val)
              begin
              s_peak_index = curr_index;
              s_peak_val = curr_val;
              end

              curr_index = curr_index+1;
            curr_val = mem[curr_index%32];
            if (curr_val<s_peak_val)
            begin
            s_peak_index = curr_index;
            s_peak_val = curr_val;
            end

            curr_index = curr_index+1;
              curr_val = mem[curr_index%32];
              if (curr_val<s_peak_val)
              begin
              s_peak_index = curr_index;
              s_peak_val = curr_val;
              end

              curr_index = curr_index+1;
                curr_val = mem[curr_index%32];
                if (curr_val<s_peak_val)
                begin
                s_peak_index = curr_index;
                s_peak_val = curr_val;
                end

                curr_index = curr_index+1;
              curr_val = mem[curr_index%32];
              if (curr_val<s_peak_val)
              begin
              s_peak_index = curr_index;
              s_peak_val = curr_val;
              end

              curr_index = curr_index+1;
                curr_val = mem[curr_index%32];
                if (curr_val<s_peak_val)
                begin
                s_peak_index = curr_index;
                s_peak_val = curr_val;
                end

                curr_index = curr_index+1;
              curr_val = mem[curr_index%32];
              if (curr_val<s_peak_val)
              begin
              s_peak_index = curr_index;
              s_peak_val = curr_val;
              end


        $display(" S peak value is %d ", s_peak_val, " and sample number is %d ", s_peak_index);
        // finally we get the S-peak value and index

        end
    end

  end


  end
endmodule
