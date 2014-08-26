package org.eclipse.xtext.example.fowlerdsl.ui.zest

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

class EObjectHandle{
	
	URI uri
	EObject element
	
	new(EObject element) {
		this.element = element
		this.uri = EcoreUtil.getURI(element)
	}
	
	def getElement() { element }
	
	def getURI() { uri }
	
	override hashCode() {
		uri.hashCode
	}

	override equals(Object obj) {
		if(obj instanceof EObjectHandle)
			return obj.uri == uri
		else
			return false
	}
	
}