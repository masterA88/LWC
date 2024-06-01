import { LightningElement, track, api } from 'lwc';

export default class DragDropScheduler extends LightningElement {
    @api title = 'Drag and Drop Scheduler'; // Exposed property for the title
    @track days = [
        { id: 'monday', name: 'Monday', tasks: [] },
        { id: 'tuesday', name: 'Tuesday', tasks: [] },
        // ... Add other days as needed
    ];

    connectedCallback() {
        // Initialize with 5 tasks
        this.days[0].tasks.push({ id: 'task1', name: 'Task 1' });
        this.days[0].tasks.push({ id: 'task2', name: 'Task 2' });
        this.days[0].tasks.push({ id: 'task3', name: 'Task 3' });
        this.days[0].tasks.push({ id: 'task4', name: 'Task 4' });
        this.days[0].tasks.push({ id: 'task5', name: 'Task 5' });
    }

    allowDrop(event) {
        event.preventDefault(); // Necessary to allow dropping
    }

    handleDragStart(event) {
        event.dataTransfer.setData("text", event.target.dataset.id); // Set the id of the draggable element
    }

    handleDrop(event) {
        event.preventDefault(); // Prevent default behavior
        const taskId = event.dataTransfer.getData("text");
        const dayId = event.currentTarget.dataset.day;

        // Find the task and day objects
        const task = this.findTask(taskId);
        const day = this.days.find(d => d.id === dayId);

        if (task && day) {
            // Add task to the new day and remove from the old
            day.tasks.push(task);
            this.removeTaskFromPreviousDay(taskId);

            // Update the component's state
            this.days = [...this.days];
        }
    }

    findTask(taskId) {
        for (const day of this.days) {
            const task = day.tasks.find(t => t.id === taskId);
            if (task) {
                return task;
            }
        }
        return null;
    }

    removeTaskFromPreviousDay(taskId) {
        for (const day of this.days) {
            const index = day.tasks.findIndex(t => t.id === taskId);
            if (index !== -1) {
                day.tasks.splice(index, 1);
                return;
            }
        }
    }
}
