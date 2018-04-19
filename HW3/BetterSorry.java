/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author RamYadav
 */
import java.util.concurrent.atomic.AtomicInteger;

public final class BetterSorry implements State {
    private byte maxval;
    private static AtomicInteger at_int[];
       
    BetterSorry(byte[] b) {
        maxval = 127;
        at_int = new AtomicInteger[b.length];
        int i = 0;
        while(i < b.length) {
           at_int[i] = new AtomicInteger(b[i]);
           i++;
        }
    }
      
    BetterSorry(byte[] b, byte maxVal) {
        maxval = maxVal;
        at_int = new AtomicInteger[b.length];
        int i = 0;
        while(i < b.length) {
           at_int[i] = new AtomicInteger(b[i]);
           i++;
        }

    } 
      
    
    @Override
    public int size() {
        return at_int.length;
    }
      
    
    @Override
    public byte[] current() {
        byte return_atmArray[] = new byte[at_int.length];
        int i = 0;
        
        while(i < at_int.length) {
           return_atmArray[i] = (byte) at_int[i].get();
           i++;
        }
        return return_atmArray;
    }

    @Override
    public boolean swap(int i, int j) {
        if (at_int[i].get() <= 0 || at_int[j].get() >= maxval) {
            return false;
        }
        at_int[i].getAndDecrement();
        at_int[j].getAndIncrement();
        return true;
    }
    
}
