package org.eclipse.xtext.example.fowlerdsl.ui.zest

import com.google.inject.Inject
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jface.text.ITextSelection
import org.eclipse.ui.IWorkbench
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.utils.EditorUtils
import org.apache.log4j.Logger

class ShowInZestViewHandler extends AbstractHandler {

	static val Logger LOG = Logger.getLogger(ShowInZestViewHandler)

	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper
	
	@Inject IWorkbench workbench
	
	override Object execute(ExecutionEvent event) throws ExecutionException {
		try {
			val editor = EditorUtils.getActiveXtextEditor(event)
			if (editor != null) {
				val selection = editor.selectionProvider.selection as ITextSelection
				editor.document.readOnly[
					val selectedElement = eObjectAtOffsetHelper.resolveElementAt(it,
							selection.offset)
					if (selectedElement != null) {
						val view = workbench.activeWorkbenchWindow.activePage.showView(ZestView.ID)
						if(view instanceof ZestView) 
							view.reveal(selectedElement)
					}
					null
				]
			}
		} catch (Exception exc) {
			LOG.error("Error opening element in diagram", exc)
		}
		return null
	}
}
