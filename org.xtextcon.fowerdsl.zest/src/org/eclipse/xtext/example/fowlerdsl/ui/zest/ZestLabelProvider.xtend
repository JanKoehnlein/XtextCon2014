package org.eclipse.xtext.example.fowlerdsl.ui.zest

import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.xtext.example.fowlerdsl.statemachine.State
import org.eclipse.xtext.example.fowlerdsl.statemachine.Transition

class ZestLabelProvider extends LabelProvider {
	
	override getText(Object handle) {
		if(handle instanceof EObjectHandle) {
			val element = handle.element 
			switch element {
				State: return element.name
				Transition: return element.event.name
			}
		} 		
		return null
	}
}