package com.cts.data.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import com.lowes.fdd.data.util.ConfigData;

public class TriggerServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		inputProcess(request, response);

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		inputProcess(request, response);

	}

	public void inputProcess(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String builttype = request.getParameter("builttype");

		String data = null;

		if (builttype != null & builttype.equalsIgnoreCase("stack")) {

			data = stack_implementation(request, response);

		} else {

			data = tools_implementation(request, response);
		}

		RequestDispatcher requestDispatcher = request.getRequestDispatcher("/home.jsp");

		requestDispatcher.forward(request, response);
	}

	private String stack_implementation(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String stack = request.getParameter("stack");
		String machine_type = request.getParameter("machine_type");
		String stack_name = request.getParameter("stack_name");

		System.out.println("Selected Stack ==> " + stack);
		System.out.println("Selected machine_type ==> " + machine_type);
		System.out.println("Selected stack_name ==> " + stack_name);

		String DATA = "stack=" + stack + "&machine_type=" + machine_type + "&stack_name=" + stack_name;

		// String JENKINS_DEPLOY_JOB =
		// "http://35.193.10.1:8080/job/StackDeploy/buildWithParameters";

		String JENKINS_DEPLOY_JOB = "http://35.193.10.1:8080/job/jenkins/buildWithParameters";
		String JENKINS_USER_TOKEN = "jenkins:jenkins";

		triggerProdInfraJob(JENKINS_DEPLOY_JOB, JENKINS_USER_TOKEN, DATA);
		
		request.setAttribute("triggerEvent", stack);

		return DATA;

	}

	private String tools_implementation(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String tool = request.getParameter("tool");
		
		String tool_name = request.getParameter("tool_name");
		String[] tools = request.getParameterValues("tools");

		System.out.println("Selected toolarray ==> " + tools);
		System.out.println("Selected tool_name ==> " + tool_name);

		String DATA = "tools=" + tools + "&tool_name=" + tool_name;

		// String JENKINS_DEPLOY_JOB =
		// "http://35.193.10.1:8080/job/ToolDeploy/buildWithParameters";

		String JENKINS_DEPLOY_JOB = "http://35.193.10.1:8080/job/jenkins/buildWithParameters";
		String JENKINS_USER_TOKEN = "jenkins:jenkins";

		triggerProdInfraJob(JENKINS_DEPLOY_JOB, JENKINS_USER_TOKEN, DATA);
		
		request.setAttribute("triggerEvent", tool);

		return DATA;

	}

	private boolean triggerProdInfraJob(String JENKINS_DEPLOY_JOB, String JENKINS_USER_TOKEN, String DATA) {

		System.out.println("CALL JENKINS JOB !!! ");

		String command = "curl -X POST " + JENKINS_DEPLOY_JOB + " --data " + "\"" + DATA + "\"" + " --user "
				+ JENKINS_USER_TOKEN;

		System.out.println(command);

		try {
			Process process = Runtime.getRuntime().exec(command);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

}
