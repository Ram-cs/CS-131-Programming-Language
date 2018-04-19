/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author RamYadav
 */
interface State {
    int size();
    byte[] current();
    boolean swap(int i, int j);
}

