import org.kohsuke.args4j.CmdLineException;
import org.kohsuke.args4j.CmdLineParser;
import org.kohsuke.args4j.Option;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class Validator {

	@Option(name = "--automaton", aliases = {"-a"}, usage = "path to an automaton", metaVar = "<automaton path>",
			required = true)
	private String automatonPath;

	@Option(name = "--dictionary", aliases = {"-d"}, usage = "path to a dictionary", metaVar = "<dictionary path>")
	private String dictionaryPath;

	@Option(name = "--percent", aliases = {"-p"}, usage = "percent of noisy data", metaVar = "<noisy percent>")
	private int p = 0;

	@Option(name = "--log", aliases = {"-l"}, usage = "write log to this file", metaVar = "<log>")
	private String logFile;

	@Option(name = "--bfs", usage = "check for BFS-enumeration", metaVar = "<bfs>")
	private boolean bfsMode;

	@Option(name = "--dfs", usage = "check for DFS-enumeration", forbids = {"--bfs"}, metaVar = "<dfs>")
	private boolean dfsMode;

	private static Logger logger = Logger.getLogger("Logger");

	private void launch(String... args) {
		CmdLineParser parser = new CmdLineParser(this);
		try {
			parser.parseArgument(args);
		} catch (CmdLineException e) {
			System.err.println(e.getMessage());
			System.err.print("Usage:");
			parser.printSingleLineUsage(System.err);
			System.err.println();
			parser.printUsage(System.err);
			return;
		}

		if (logFile != null) {
			try {
				FileHandler fh = new FileHandler(logFile, false);
				logger.addHandler(fh);
				fh.setFormatter(new SimpleFormatter());
				logger.setUseParentHandlers(false);
				System.out.println("Log file: " + logFile);
			} catch (Exception e) {
				System.err.println("Problem with log file: " + logFile + ". " + e.getMessage());
				return;
			}
		}


		try {
			logger.info("Building automaton from file \"" + automatonPath + "\".");
			Automaton automaton = new Automaton(new File(automatonPath));
			boolean correct = false;

			try (BufferedReader br = new BufferedReader(new FileReader(dictionaryPath))) {
				logger.info("Parsing dictionary file \"" + dictionaryPath + "\".");
				int lines = Integer.parseInt(br.readLine().split("\\s+")[0]);
				int mistakes = 0;
				int mistakesMax = (int) Math.round((lines / 100.0) * p);

				for (int line = 0; line < lines; line++) {
					// <status> <len> [label ...]
					String wordStr = br.readLine();
					List<String> word = new ArrayList<>(Arrays.asList(wordStr.split("\\s+")));
					assert word.size() == Integer.parseInt(word.get(1));
					Node.Status status = automaton.proceedWord(word.subList(2, word.size()));
					if (status == Node.Status.ACCEPTABLE && word.get(0).equals("1")) {
						continue;
					}
					if (status == Node.Status.REJECTABLE && word.get(0).equals("0")) {
						continue;
					}
					mistakes++;
				}
				if (mistakes <= mistakesMax) {
					correct = true;
					logger.info("The automaton recognized dictionary correctly.");
				} else {
					correct = false;
					logger.info("The automaton recognized dictionary INcorrectly");
				}
				logger.info("Mistakes found: " + mistakes + ". Mistakes allowed: " + mistakesMax + ".");
			} catch (IOException e) {
				logger.warning("Some unexpected problem with file \"" + dictionaryPath + "\":" + e.getMessage());
			}

			if (correct) {
				if (bfsMode) {
					logger.info("Checking for BFS-enumeration started.");
					if (new BFSChecker(automaton).check()) {
						logger.info("The automaton is BFS-enumerated! Congrats :)");
					} else {
						logger.warning("The automaton is not BFS-enumerated! Too sad :(");
					}
				}
				if (dfsMode) {
					logger.info("Checking for DFS-enumeration started.");
					if (new DFSChecker(automaton).check()) {
						logger.info("The automaton is DFS-enumerated! Congrats :)");
					} else {
						logger.warning("The automaton is not DFS-enumerated! Too sad :(");
					}
				}
			}
		} catch (IOException e) {
			logger.warning("Some unexpected problem with file \"" + automatonPath + "\":" + e.getMessage());
		}
	}

	private class BFSChecker {
		Automaton automaton;
		Queue<Node> queue;
		boolean[] visited;
		List<String> alphabet;
		int expected;

		BFSChecker(Automaton automaton) {
			this.automaton = automaton;
			queue = new LinkedList<>();
			visited = new boolean[automaton.size()];
			alphabet = new ArrayList<>(automaton.getStart().getChildren().keySet());
			Collections.sort(alphabet);
			expected = 0;
		}

		boolean check() {
			queue.add(automaton.getStart());
			visited[automaton.getStart().getNumber()] = true;
			Node cur;
			while (!queue.isEmpty()) {
				cur = queue.remove();
				if (cur.getNumber() != expected++) {
					return false;
				}
				for (String label : alphabet) {
					Node child = cur.getChild(label);
					if (!visited[child.getNumber()]) {
						visited[child.getNumber()] = true;
						queue.add(child);
					}
				}
			}
			return true;
		}
	}

	private class DFSChecker {
		Automaton automaton;
		boolean visited[];
		int expected;
		List<String> alphabet;

		DFSChecker(Automaton automaton) {
			this.automaton = automaton;
			visited = new boolean[automaton.size()];
			alphabet = new ArrayList<>(automaton.getStart().getChildren().keySet());
			Collections.sort(alphabet);
			expected = 0;
		}

		boolean check() {
			return dfs(automaton.getStart());
		}

		boolean dfs(Node cur) {
			visited[cur.getNumber()] = true;
			boolean res = true;

			if (cur.getNumber() != expected++) {
				return false;
			}
			for (String label : alphabet) {
				Node child = cur.getChild(label);
				if (!visited[child.getNumber()]) {
					res &= dfs(child);
				}
			}
			return res;
		}
	}

	private void run(String... args) {
		Locale.setDefault(Locale.US);
		try {
			launch(args);
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}

	public static void main(String... args) {
		new Validator().run(args);
	}
}
