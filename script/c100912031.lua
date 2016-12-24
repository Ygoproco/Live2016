--影霊衣の巫女 エリアル
--Ariel, Priestess of the Nekroz
--Script by nekrozar
function c100912031.initial_effect(c)
	--level change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100912031,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c100912031.lvcost)
	e1:SetOperation(c100912031.lvop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912031,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,100912031)
	e2:SetCondition(c100912031.thcon)
	e2:SetTarget(c100912031.thtg)
	e2:SetOperation(c100912031.thop)
	c:RegisterEffect(e2)
end
function c100912031.cfilter(c)
	return c:IsSetCard(0xb4) and not c:IsPublic()
end
function c100912031.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100912031.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100912031.cfilter,tp,LOCATION_HAND,0,1,63,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetCount())
end
function c100912031.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=e:GetLabel()
	local sel=nil
	if c:GetLevel()==1 then
		sel=Duel.SelectOption(tp,aux.Stringid(100912031,2))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(100912031,2),aux.Stringid(100912031,3))
	end
	if sel==1 then
		ct=ct*-1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c100912031.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c100912031.filter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c100912031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100912031.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100912031.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100912031.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end