package org.eclipse.xtext.example.fowlerdsl.ui.zest

import org.eclipse.jface.viewers.Viewer
import org.eclipse.xtext.example.fowlerdsl.statemachine.State
import org.eclipse.xtext.example.fowlerdsl.statemachine.Statemachine
import org.eclipse.zest.core.viewers.IGraphEntityRelationshipContentProvider

class ZestContentProvider implements IGraphEntityRelationshipContentProvider {

	override getElements(Object inputElement) {
		if (inputElement instanceof Statemachine)
			return inputElement.states.map[new EObjectHandle(it)]
		else
			return #[]
	}

	override dispose() {
	}

	override inputChanged(Viewer viewer, Object oldInput, Object newInput) {
	}

	override getRelationships(Object sourceHandle, Object destHandle) {
		if (sourceHandle instanceof EObjectHandle) {
			val source = sourceHandle.element
			if (destHandle instanceof EObjectHandle) {
				val dest = destHandle.element
				if (source instanceof State)
					return source.transitions.filter[state == dest].map[new EObjectHandle(it)]
			}
		}
		return #[]
	}
}
