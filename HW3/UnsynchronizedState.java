/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author RamYadav
 */
class UnsynchronizedState implements State {
    public static void main(String[] args) {
       
    } 
    private byte[] value;
    private byte maxval;

    UnsynchronizedState(byte[] v) { value = v; maxval = 127; }

    UnsynchronizedState(byte[] v, byte m) { value = v; maxval = m; }

    public int size() { return value.length; }

    public byte[] current() { return value; }

    public boolean swap(int i, int j) {
	if (value[i] <= 0 || value[j] >= maxval) {
	    return false;
	}
	value[i]--;
	value[j]++;
	return true;
    }    
    
    
}

