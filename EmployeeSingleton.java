package com.cts.singleton;

import java.io.Serializable;

public class EmployeeSingleton implements Cloneable, Serializable {

	private static EmployeeSingleton emp = null;
	private static boolean flag = false;

	private EmployeeSingleton() {



		if (flag) {
			throw new RuntimeException("second time obj creation not allowed");
		} else {
			flag = true;
			System.out.println("Emp obj created");
		}
	}

	public synchronized static EmployeeSingleton getInstance() {
		if (emp == null) {
			emp = new EmployeeSingleton();
		}
		return emp;
	}

	@Override
	protected Object clone() throws CloneNotSupportedException {
		System.out.println("clone");
		return getInstance();
	}

	// for deserilizations issue
	public Object readResolve() {
		System.out.println("readREsolver method");
		return getInstance();
	}
}
