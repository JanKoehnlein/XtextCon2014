package org.eclipse.xtext.example.fowlerdsl.ui.zest

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.viewers.ISelectionChangedListener
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.part.ViewPart
import org.eclipse.xtext.example.fowlerdsl.statemachine.State
import org.eclipse.xtext.example.fowlerdsl.statemachine.Statemachine
import org.eclipse.xtext.ui.editor.IURIEditorOpener
import org.eclipse.zest.core.viewers.GraphViewer
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart
import org.eclipse.zest.core.viewers.ZoomContributionViewItem
import org.eclipse.zest.core.widgets.ZestStyles
import org.eclipse.zest.layouts.LayoutStyles
import org.eclipse.zest.layouts.algorithms.SpringLayoutAlgorithm

class ZestView extends ViewPart implements IZoomableWorkbenchPart {

	public static val ID = "org.eclipse.xtext.example.fowlerdsl.ui.zest.ZestView"
	 	
	GraphViewer viewer
	ISelectionChangedListener selectionListener
	
	@Inject ZestContentProvider zestContentProvider
	@Inject ZestLabelProvider zestLabelProvider
	@Inject IURIEditorOpener editorOpener
	
	override createPartControl(Composite parent) {
		viewer = createViewer(parent)
	    viewSite.actionBars.menuManager.add(new ZoomContributionViewItem(this))
	}
	
	def createViewer(Composite parent) {
		new GraphViewer(parent, SWT.BORDER) => [
			contentProvider = zestContentProvider
			labelProvider = zestLabelProvider 
			setLayoutAlgorithm(new SpringLayoutAlgorithm(LayoutStyles.NO_LAYOUT_NODE_RESIZING), true)
			connectionStyle = ZestStyles.CONNECTIONS_DIRECTED
			nodeStyle = ZestStyles.NODES_FISHEYE 
			applyLayout
			selectionListener = [ event | 
				val selection = event.selection as IStructuredSelection
				if(selection.size == 1) {
					val selectedElement = selection.firstElement
					if(selectedElement instanceof EObjectHandle)
						editorOpener.open(selectedElement.URI, true)
				}
			]
			addSelectionChangedListener(selectionListener)
		]
	}

	def reveal(EObject it) {
		switch it {
			State: {
				viewer.input = eContainer as Statemachine
				viewer.reveal(new EObjectHandle(it))
			}
			Statemachine: 
				viewer.input = eContainer as Statemachine
		}
	}
	
	override setFocus() {
	}
	
	override getZoomableViewer() {
		viewer
	}
	
	override dispose() {
		viewer.removeSelectionChangedListener(selectionListener)
		super.dispose()
	}
	
}

