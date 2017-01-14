--十二獣の方合
--Seasonal Direction of the Zodiac Beasts
--Scripted by Eerie Code
function c73881652.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c73881652.xyztg)
	e1:SetOperation(c73881652.xyzop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c73881652.tdtg)
	e2:SetOperation(c73881652.tdop)
	c:RegisterEffect(e2)
end

function c73881652.xyzfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xf1)
end
function c73881652.xyzfil2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf1)
end
function c73881652.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c73881652.xyzfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73881652.xyzfil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c73881652.xyzfil2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c73881652.xyzfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c73881652.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c73881652.xyzfil2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end

function c73881652.tdfil(c)
	return c:IsSetCard(0xf1) and c:IsAbleToDeck()
end
function c73881652.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c73881652.tdfil,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=5 and Duel.IsPlayerCanDraw(tp,1) end
	local mg=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		mg:AddCard(sg:GetFirst())
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	end
	Duel.SetTargetCard(mg)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,mg,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c73881652.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g,p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==5 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==5 then
		if g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<5 then Duel.ShuffleDeck(p) end
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end