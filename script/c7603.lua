--捕食植物プテロペンテス
--Predator Plant Pteropenthes
--Scripted by Eerie Code
function c7603.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7603,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c7603.ctcon)
	e1:SetTarget(c7603.cttg)
	e1:SetOperation(c7603.ctop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7603,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c7603.tg)
	e2:SetOperation(c7603.op)
	c:RegisterEffect(e2)
end

function c7603.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c7603.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsCanAddCounter(0x1041,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1041,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1041,1)
end
function c7603.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x1041,1) and tc:GetLevel()>1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c7603.lvcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c7603.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end

function c7603.fil(c,lv)
	return c:IsFaceup() and c:IsLevelBelow(lv) and c:IsAbleToChangeControler()
end
function c7603.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c7603.fil(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(c7603.fil,tp,0,LOCATION_MZONE,1,nil,lv) end
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c7603.fil,tp,0,LOCATION_MZONE,1,1,nil,lv)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c7603.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelBelow(e:GetLabel()) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
