import React, { useState } from "react";

export default function Todo(props) {
	const [isEditing, setEditing] = useState(false);
	const [newName, setNewName] = useState('');

	function handleChange(e) {
		setNewName(e.target.value);
	}
	
	function handleSubmit(e) {
		e.preventDefault();
		props.editTask(props.id, newName);
		setNewName("");
		setEditing(false);
	}

	const editingTemplate = (
		<form className="stack-small" onSubmit={handleSubmit}>
			<div className="form-group">
				<label className="todo-label" htmlFor={props.id}>
					New title for {props.title}
				</label>
				<input id={props.id} className="todo-text" type="text" onChange={handleChange} />
			</div>
			<div className="btn-group">
				<button type="button" className="btn todo-cancel" onClick={() => setEditing(false)}>
					Cancel
        <span className="visually-hidden">renaming {props.title}</span>
				</button>
				<button type="submit" className="btn btn__primary todo-edit">
					Save
        <span className="visually-hidden">new title for {props.title}</span>
				</button>
			</div>
		</form>
	);
	const viewTemplate = (
		<div className="stack-small">
			<div className="c-cb">
				<input
					id={props.id}
					type="checkbox"
					defaultChecked={props.isComplete}
					onChange={() => props.toggleTaskCompleted(props.id)}
				/>
				<label className="todo-label" htmlFor={props.id}>
					{props.title} - {props.isComplete}
				</label>
			</div>
			<div className="btn-group">
				<button type="button" className="btn" onClick={() => setEditing(true)}>
					Edit <span className="visually-hidden">{props.title}</span>
				</button>
				<button
					type="button"
					className="btn btn__danger"
					onClick={() => props.deleteTask(props.id)}
				>
					Delete <span className="visually-hidden">{props.title}</span>
				</button>
			</div>
		</div>
	);

	return (
	<li className="todo">{isEditing ? editingTemplate : viewTemplate}</li>
	);
}