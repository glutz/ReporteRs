package com.lysis.docx4r.datatable.data;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Vector;

import javax.xml.bind.JAXBException;

import org.docx4j.XmlUtils;
import org.docx4j.dml.CTRegularTextRun;
import org.docx4j.dml.CTTableCellProperties;
import org.docx4j.dml.CTTextBody;
import org.docx4j.dml.CTTextBodyProperties;
import org.docx4j.dml.CTTextCharacterProperties;
import org.docx4j.dml.CTTextListStyle;
import org.docx4j.dml.CTTextParagraph;
import org.docx4j.wml.P;
import org.docx4j.wml.PPr;
import org.docx4j.wml.R;
import org.docx4j.wml.RPr;
import org.docx4j.wml.TcPr;
import org.docx4j.wml.Text;
import org.rendersnake.HtmlAttributes;
import org.rendersnake.HtmlCanvas;

import com.lysis.pptx4r.tools.Format;
import com.lysis.reporters.tables.TableLayoutDOCX;

public class RCharacter implements RAtomicInterface{
	Vector<String> data;
	
	public RCharacter(Vector<String> data){
		this.data = data;
	}
	
	@Override
	public void print() {
		for( int i = 0 ; i < size() ; i ++ ){
			System.out.println(data.get(i));
		}
	}

	@Override
	public int size() {
		return data.size();
	}


	@Override
	public Object get(int i) {
		return data.get(i);
	}


	public P getP(int i, TableLayoutDOCX tf) {
		P p = new P();
		R run = new R();
		Text text = new Text();
		PPr parProperties = tf.getCharacterPar();
		RPr textProperties = tf.getCharacterText();

		text.setValue(data.get(i));
		run.getContent().add(text);
		run.setRPr(textProperties);
		p.getContent().add(run);
		p.setPPr(parProperties);
		return p;
	}
	public P getP(int i, TableLayoutDOCX tf, String fontColor) {
		P p = new P();
		R run = new R();
		Text text = new Text();
		PPr parProperties = tf.getCharacterPar();
		RPr textProperties = XmlUtils.deepCopy(tf.getCharacterText());
		org.docx4j.wml.Color col = new org.docx4j.wml.Color();
		col.setVal(fontColor);
		textProperties.setColor(col);

		
		text.setValue(data.get(i));
		run.getContent().add(text);
		run.setRPr(textProperties);
		p.getContent().add(run);
		p.setPPr(parProperties);
		return p;
	}

	@Override
	public TcPr getCellProperties(TableLayoutDOCX tf) {
		return tf.getCharacterCell();
	}

	@Override
	public CTTextBody getP(int i, com.lysis.reporters.tables.TableLayoutPPTX tf) throws JAXBException {
		CTTextBody p = new CTTextBody();
		CTTextBodyProperties pp = new CTTextBodyProperties();
		CTTextListStyle ls = new CTTextListStyle();
		p.setBodyPr(pp);
		p.setLstStyle(ls);
		
		CTRegularTextRun textRun = com.lysis.pptx4r.elements.Utils.getRun(data.get(i));
		textRun.setRPr(tf.getCharacterText());
		
		CTTextParagraph textPar = new CTTextParagraph();
		List<Object> runs = textPar.getEGTextRun();
		runs.add(textRun);
		
		textPar.setPPr(tf.getCharacterPar());
		p.getP().add(textPar);
		return p;		
	}

	@Override
	public CTTextBody getP(int i, com.lysis.reporters.tables.TableLayoutPPTX tf,
			String fontColor) throws Exception {
		CTTextBody p = new CTTextBody();
		CTTextBodyProperties pp = new CTTextBodyProperties();
		CTTextListStyle ls = new CTTextListStyle();
		p.setBodyPr(pp);
		p.setLstStyle(ls);
		
		CTRegularTextRun textRun = com.lysis.pptx4r.elements.Utils.getRun(data.get(i));
		CTTextCharacterProperties chartext = XmlUtils.deepCopy(tf.getCharacterText());
		chartext.setSolidFill(Format.getCol(fontColor));
		textRun.setRPr(chartext);
		
		CTTextParagraph textPar = new CTTextParagraph();
		List<Object> runs = textPar.getEGTextRun();
		runs.add(textRun);
		
		textPar.setPPr(tf.getCharacterPar());
		p.getP().add(textPar);
		return p;
	}

	@Override
	public CTTableCellProperties getCellProperties(com.lysis.reporters.tables.TableLayoutPPTX tf) {
		return tf.getCharacterCell();
	}

	@Override
	public void setP(HtmlCanvas html, int i, com.lysis.reporters.tables.TableLayoutHTML tf) throws IOException {
		HtmlAttributes ha_p = new HtmlAttributes();
		ha_p.class_("CharacterPar");
		HtmlAttributes ha_s = new HtmlAttributes();
		ha_s.class_("CharacterText");

		HtmlCanvas out = html.p(ha_p);
		HtmlCanvas span = out.span(ha_s);
		
		span.content(org.apache.commons.lang.StringEscapeUtils.escapeHtml(data.get(i))
				, false);	
		out._p();
	}

	@Override
	public void setP(HtmlCanvas html, int i, com.lysis.reporters.tables.TableLayoutHTML tf, String fontColor)
			throws IOException {
		HtmlAttributes ha_p = new HtmlAttributes();
		ha_p.class_("CharacterPar");
		HtmlAttributes ha_s = new HtmlAttributes();
		LinkedHashMap<String, String> charF = new LinkedHashMap<String, String>();
		charF.put("color",fontColor);
		ha_s.add("style", com.lysis.html4r.tools.Format.getJSString(charF));
		ha_s.class_("CharacterText");

		HtmlCanvas out = html.p(ha_p);

		HtmlCanvas span = out.span(ha_s);
		span.content(org.apache.commons.lang.StringEscapeUtils.escapeHtml(data.get(i))
				, false);	
		out._p();
	}

	@Override
	public LinkedHashMap<String, String> getCellProperties(
			com.lysis.reporters.tables.TableLayoutHTML tf) {
		return tf.getCharacterCell();
	}

	@Override
	public String getTdCssClass() {
		return "CharacterCell";
	}
}
