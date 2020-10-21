import React, { useEffect, useState } from 'react';
import { nanoid } from "nanoid";
import axios from 'axios';
import Form from "./components/Form";
import FilterButton from "./components/FilterButton"
import Todo from "./components/Todo";

const FILTER_MAP = {
	All: () => true,
	Active: task => !task.isComplete,
	IsComplete: task => task.isComplete
};

const FILTER_NAMES = Object.keys(FILTER_MAP);

function App(props) {
	const [tasks, setTasks] = useState(props.tasks);
	const [filter, setFilter] = useState('All');

	const taskList = tasks
		.filter(FILTER_MAP[filter])
		.map(task => (
			<Todo
				id={task.id}
				title={task.title}
				isComplete={task.isComplete}
				key={task.id}
				toggleTaskCompleted={toggleTaskCompleted}
				deleteTask={deleteTask}
				editTask={editTask}
			/>
		));

	useEffect(() => {
		const fetchData = async () => {
			const result = await axios('https://localhost:5001/api/todo',);
			setTasks(result.data.todos);
		};

		fetchData();
	}, []);

	const filterList = FILTER_NAMES.map(name => (
		<FilterButton
			key={name}
			name={name}
			isPressed={name === filter}
			setFilter={setFilter}
		/>
	));

	function addTask(title) {
		const newTask = { id: "todo-" + nanoid(), title: title, isComplete: false };
		setTasks([...tasks, newTask]);
	}

	function editTask(id, newName) {
		const editedTaskList = tasks.map(task => {
			// if this task has the same ID as the edited task
			if (id === task.id) {
				//
				return { ...task, title: newName }
			}
			return task;
		});
		setTasks(editedTaskList);
	}

	function deleteTask(id) {
		const remainingTasks = tasks.filter(task => id !== task.id);
		setTasks(remainingTasks);
	}

	function toggleTaskCompleted(id) {
		const updatedTasks = tasks.map(task => {
			if (id === task.id) {
				return { ...task, isComplete: !task.isComplete };
			}
			return task;
		});
		setTasks(updatedTasks);
	}

	const tasksNoun = taskList.length !== 1 ? 'tasks' : 'task';
	const headingText = `${taskList.length} ${tasksNoun} remaining`;

	return (
		<div className="todoapp stack-large">
			<div className="todoapp stack-large">
				<Form addTask={addTask} />
				<div className="filters btn-group stack-exception">
					{filterList}
				</div>
				<h2 id="list-heading">{headingText}</h2>
				<ul
					className="todo-list stack-large stack-exception"
					aria-labelledby="list-heading"
				>
					{taskList}
				</ul>
			</div>
		</div>
	);
}



export default App;
